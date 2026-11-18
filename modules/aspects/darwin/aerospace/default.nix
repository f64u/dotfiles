{ lib, ... }:
{
  den.aspects.darwin-aerospace.darwin =
    { pkgs, ... }:
    let
      # 1-9: there is no alt-10 key.
      workspaces = map toString (lib.range 1 9);

      # Switching workspace can key an app's window on the other monitor, and
      # aerospace follows. Half a second later, if focus left workspace $1
      # that way (and no other alt-N came since), focus $1 again.
      holdFocus = pkgs.writeShellScript "aerospace-hold-focus" ''
        aerospace=/run/current-system/sw/bin/aerospace
        target=/tmp/aerospace-target-$(id -u)
        echo "$1" > "$target"
        sleep 0.5
        [ "$(cat "$target")" = "$1" ] || exit 0
        [ "$($aerospace list-workspaces --focused)" != "$1" ] || exit 0
        app=$($aerospace list-windows --focused --format '%{app-bundle-id}' 2>/dev/null)
        [ -n "$app" ] || exit 0
        $aerospace list-windows --workspace "$1" --format '%{app-bundle-id}' | grep -qxF "$app" || exit 0
        $aerospace workspace "$1"
      '';

      # Keyboard commands that may change monitor stamp the time first, so
      # followMouse leaves them alone.
      stamp = pkgs.writeShellScript "aerospace-stamp" ''
        echo "''${EPOCHREALTIME/[.,]/}" > /tmp/aerospace-keyboard-$UID
      '';
      kb = cmds: [ "exec-and-forget ${stamp}" ] ++ lib.toList cmds;

      # Cmd-Tab, the Dock or a link may key an app's window on the other
      # monitor. If the app has a visible window on the mouse's screen, focus
      # that; otherwise bring the mouse along.
      followMouse = pkgs.writeShellScript "aerospace-follow-mouse" ''
        aerospace=/run/current-system/sw/bin/aerospace
        read -r at 2>/dev/null < /tmp/aerospace-keyboard-$UID
        if (( ''${EPOCHREALTIME/[.,]/} - ''${at:-0} < 1000000 )); then
          exec $aerospace move-mouse monitor-lazy-center
        fi
        # Empty unless the mouse is on the focused monitor.
        [ -z "$($aerospace list-monitors --focused --mouse)" ] || exit 0
        app=$($aerospace list-windows --focused --format '%{app-bundle-id}' 2>/dev/null)
        id=$([ -n "$app" ] && $aerospace list-windows --monitor mouse --workspace visible \
          --app-bundle-id "$app" --format '%{window-id}')
        [ -n "$id" ] && exec $aerospace focus --window-id "''${id%%$'\n'*}"
        exec $aerospace move-mouse monitor-lazy-center
      '';

      # `alt-N` focuses workspace N.
      focusBindings = lib.listToAttrs (
        map (
          n:
          lib.nameValuePair "alt-${n}" (kb [
            "workspace ${n}"
            "exec-and-forget ${holdFocus} ${n}"
          ])
        ) workspaces
      );

      # `alt-shift-N` moves the window to workspace N, follows it, and tells
      # sketchybar.
      moveBindings = lib.listToAttrs (
        map (
          n:
          lib.nameValuePair "alt-shift-${n}" (kb [
            "move-node-to-workspace ${n}"
            "workspace ${n}"
            "exec-and-forget /run/current-system/sw/bin/sketchybar --trigger windows_on_spaces"
          ])
        ) workspaces
      );
    in
    {
      services.aerospace = {
        enable = true;
        settings = {
          # No `after-startup-command` for sketchybar: home-manager runs it under
          # launchd.

          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;

          # Version 2 wants persistent workspaces listed; 1 infers them and warns.
          config-version = 2;
          persistent-workspaces = workspaces;

          accordion-padding = 30;

          default-root-container-layout = "tiles";
          default-root-container-orientation = "auto";

          key-mapping.preset = "qwerty";

          on-focused-monitor-changed = [ "exec-and-forget ${followMouse}" ];
          # sketchybar's front_app: closing the last window changes no
          # workspace and no macOS front app.
          on-focus-changed = [
            "exec-and-forget /run/current-system/sw/bin/sketchybar --trigger aerospace_focus_change"
          ];

          gaps = {
            inner.horizontal = 10;
            inner.vertical = 10;
            outer.left = 10;
            outer.bottom = 10;
            # Leaves 10pt below sketchybar (40pt), which on the built-in display
            # starts inside the ~35pt notch strip.
            outer.top = [
              { monitor.main = 15; }
              { monitor.secondary = 50; }
              15
            ];
            outer.right = 10;
          };

          mode.main.binding = {
            # Focus window
            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            # Move window
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";

            # Monitors. h/l walk aerospace's list (left-to-right, top-to-bottom);
            # k/j only fire when a monitor is actually above/below.
            alt-ctrl-h = kb "focus-monitor --wrap-around prev";
            alt-ctrl-l = kb "focus-monitor --wrap-around next";
            alt-ctrl-k = kb "focus-monitor up";
            alt-ctrl-j = kb "focus-monitor down";

            alt-ctrl-shift-h = kb "move-node-to-monitor --wrap-around --focus-follows-window prev";
            alt-ctrl-shift-l = kb "move-node-to-monitor --wrap-around --focus-follows-window next";
            alt-ctrl-shift-k = kb "move-node-to-monitor --focus-follows-window up";
            alt-ctrl-shift-j = kb "move-node-to-monitor --focus-follows-window down";

            # Flatten the workspace tree.
            alt-r = "flatten-workspace-tree";

            # Toggle fullscreen
            alt-f = "fullscreen";

            # sketchybar sits above the auto-hiding menu bar so clicks on it
            # land; this drops it behind (and back) to reach the menu bar.
            alt-m = "exec-and-forget /run/current-system/sw/bin/sketchybar --trigger toggle_menubar";

            # Float / unfloat window
            alt-t = "layout floating tiling";

            # Toggle split orientation
            alt-e = "layout tiles horizontal vertical";

            # Balance windows
            alt-shift-0 = "balance-sizes";

            # Focus workspace
            alt-tab = kb "workspace-back-and-forth";
          }
          // focusBindings
          // moveBindings;

          # App-specific rules
          on-window-detected = [
            # App to workspace assignments
            {
              "if".app-id = "company.thebrowser.dia";
              run = "move-node-to-workspace 1";
            }
            {
              "if".app-id = "com.github.wez.wezterm";
              run = "move-node-to-workspace 2";
            }
            {
              "if".app-id = "com.tinyspeck.slackmacgap";
              run = "move-node-to-workspace 5";
            }
            {
              "if".app-id = "com.spotify.client";
              run = "move-node-to-workspace 6";
            }
            # Floating windows
            {
              "if".app-id = "com.apple.archiveutility";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.Music";
              run = "layout floating";
            }
            {
              "if".app-id = "com.raycast.macos";
              run = "layout floating";
            }
            {
              "if".app-id = "eu.exelban.Stats";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.calculator";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.systempreferences";
              run = "layout floating";
            }
            {
              "if" = {
                app-id = "com.apple.Safari";
                window-title-regex-substring = "^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advanced)$";
              };
              run = "layout floating";
            }
            {
              "if" = {
                app-id = "com.apple.finder";
                window-title-regex-substring = "(Co(py|nnect)|Move|Info|Pref)";
              };
              run = "layout floating";
            }
          ];

          # Tells sketchybar. `windows_on_spaces` comes from the alt-shift-N bindings.
          exec-on-workspace-change = [
            "/bin/bash"
            "-c"
            "/run/current-system/sw/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
          ];

          # Monitor 1 = external, 2 = built-in. sketchybar follows this.
          workspace-to-monitor-force-assignment = {
            "1" = 2; # Built-in display (main)
            "2" = 2;
            "3" = 2;
            "4" = 2;
            "5" = 2;
            "6" = 2;
            "7" = 2;
            "8" = 1; # External display
            "9" = 1;
          };
        };
      };
    };
}

{ lib, ... }:
{
  den.aspects.aerospace.darwin =
    { ... }:
    let
      # 1-9. There is no alt-10 key, and alt-shift-0 is already balance-sizes,
      # so a tenth workspace has nowhere to bind -- the stale
      # workspace-to-monitor entry for "10" is dropped below to match.
      workspaces = map toString (lib.range 1 9);

      # `alt-N` focuses workspace N.
      focusBindings = lib.listToAttrs (map (n: lib.nameValuePair "alt-${n}" "workspace ${n}") workspaces);

      # `alt-shift-N` moves the focused window to workspace N, follows it, and
      # nudges sketchybar to redraw its per-workspace app icons.
      moveBindings = lib.listToAttrs (
        map (
          n:
          lib.nameValuePair "alt-shift-${n}" [
            "move-node-to-workspace ${n}"
            "workspace ${n}"
            "exec-and-forget sketchybar --trigger windows_on_spaces"
          ]
        ) workspaces
      );
    in
    {
      services.aerospace = {
        enable = true;
        settings = {
          # NOTE: no `after-startup-command = ["exec-and-forget sketchybar"]`.
          # home-manager's programs.sketchybar already creates a launchd agent
          # with RunAtLoad + KeepAlive, and aerospace's launchd PATH does not
          # contain the nix profile anyway -- so that line either did nothing
          # or started a second, unwrapped bar that cannot load the Lua config.

          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;

          accordion-padding = 30;

          default-root-container-layout = "tiles";
          default-root-container-orientation = "auto";

          key-mapping.preset = "qwerty";

          on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

          gaps = {
            inner.horizontal = 10;
            inner.vertical = 10;
            outer.left = 10;
            outer.bottom = 10;
            outer.top = [
              { monitor.main = 10; }
              { monitor.secondary = 48; }
              10
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

            # Focus monitor
            alt-ctrl-k = "focus-monitor up";
            alt-ctrl-j = "focus-monitor down";

            # Move window to monitor
            alt-ctrl-shift-k = [
              "move-node-to-monitor up"
              "focus-monitor up"
            ];
            alt-ctrl-shift-j = [
              "move-node-to-monitor down"
              "focus-monitor down"
            ];

            # Flatten the workspace tree. (`alt-r` and `alt-e` were both bound
            # to the same `layout tiles horizontal vertical` command; alt-e
            # keeps that job below.)
            alt-r = "flatten-workspace-tree";

            # Toggle fullscreen
            alt-f = "fullscreen";

            # Float / unfloat window
            alt-t = "layout floating tiling";

            # Toggle split orientation
            alt-e = "layout tiles horizontal vertical";

            # Balance windows
            alt-shift-0 = "balance-sizes";

            # Focus workspace
            alt-tab = "workspace-back-and-forth";

            # Service commands
            alt-shift-semicolon = "mode service";
          }
          // focusBindings
          // moveBindings;

          mode.service.binding = {
            esc = [
              "reload-config"
              "mode main"
            ];
            r = [
              "flatten-workspace-tree"
              "mode main"
            ];
            backspace = [
              "close-all-windows-but-current"
              "mode main"
            ];
          };

          # App-specific rules
          on-window-detected = [
            # App to workspace assignments
            {
              "if".app-id = "company.thebrowser.Browser";
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
                window-title-regex-substring = "^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$";
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

          # Sketchybar integration callback.
          #
          # NOTE: only `aerospace_workspace_change` is fired. spaces.lua also
          # subscribes to `windows_on_spaces` with the same handler, so firing
          # both here made every workspace switch refresh the icon strip twice.
          exec-on-workspace-change = [
            "/bin/bash"
            "-c"
            "/run/current-system/sw/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
          ];

          # Workspace to monitor assignment
          # Aerospace: Monitor 1 = external, Monitor 2 = Built-in (main)
          # Sketchybar: Display 1 = main, Display 2 = external
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

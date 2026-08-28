{
  den.aspects.programs-neovim.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # `xdg.configFile."nvim"` rather than `home.file."./.config/nvim/"`: the
      # latter's target was taken verbatim, so it linked $HOME/./.config/nvim/
      # and could never collide-check against what programs.neovim emits.
      #
      # `recursive = true` is load-bearing, not cosmetic -- without it the
      # directory itself becomes one read-only symlink and the lazy-lock
      # seeding below could not create a file inside it.
      #
      # NOTE: init.lua is deliberately NOT in this tree. programs.neovim also
      # writes nvim/init.lua, and when both did, the repo copy won silently by
      # ordering -- which is why `withPython3 = false` / `withRuby = false`
      # below had no effect at all. It is passed as extraLuaConfig instead, so
      # there is exactly one writer.
      xdg.configFile = {
        "nvim/lua".source = ./config/lua;
        "nvim/spell".source = ./config/spell;
      };

      # lazy.nvim's plugin pins. This cannot be a store symlink -- lazy
      # rewrites it on `:Lazy update` -- so seed it only when absent: a fresh
      # machine gets the committed revisions, an existing one keeps its own.
      #
      # After `:Lazy update`, copy the new pins back into the repo:
      #   cp ~/.config/nvim/lazy-lock.json \
      #      ~/.config/nix/modules/aspects/programs/neovim/lazy-lock.json
      home.activation.seedLazyLock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        lock="${config.home.homeDirectory}/.config/nvim/lazy-lock.json"
        if [ ! -e "$lock" ]; then
          run mkdir -p "$(dirname "$lock")"
          run cp ${./lazy-lock.json} "$lock"
          run chmod u+w "$lock"
        fi

        # `zg`/`zw` write to 'spellfile'; settings.lua points it here so it
        # does not land on the read-only nvim/spell store symlink.
        run mkdir -p "${config.xdg.stateHome}/nvim/spell"
      '';

      programs.neovim = {
        enable = true;
        defaultEditor = true;

        initLua = builtins.readFile ./config/init.lua;

        # Adopt the post-26.05 upstream defaults. Nothing here uses the pynvim
        # or neovim-ruby remote-plugin providers -- nvim-dap-python runs
        # debugpy through `uv`, which is unrelated to withPython3.
        withPython3 = false;
        withRuby = false;

        # Everything custom/configs/lsp.lua enables, plus the toolchain the
        # plugins shell out to. Servers already pulled in by
        # packages-development (nil, bash-language-server, ccls, taplo, texlab,
        # tinymist, lua-language-server, millet) are not repeated.
        extraPackages = with pkgs; [
          basedpyright
          ruff
          vscode-langservers-extracted # html, cssls, jsonls
          lldb # lldb-dap, for the nvim-dap C/C++/Rust adapter

          # telescope-fzf-native and nvim-treesitter both compile at runtime.
          # These came from Xcode CLT by accident on macOS; declaring them
          # means the config does not depend on that.
          gnumake
          stdenv.cc
        ];
      };
    };
}

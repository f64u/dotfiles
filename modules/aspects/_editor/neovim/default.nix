# A module of den.aspects.editor.
{ ... }:
{
  homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # Not init.lua: programs.neovim writes that from `initLua` below.
      xdg.configFile = {
        "nvim/lua".source = ./config/lua;
        "nvim/spell".source = ./config/spell;
      };

      # lazy.nvim rewrites its lockfile, so it is seeded, not linked. After
      # `:Lazy update`, copy ~/.config/nvim/lazy-lock.json back here.
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

        # Read by plugins/theme.lua.
        initLua = ''
          vim.g.catppuccin_flavour = "${config.catppuccin.flavor}"
        ''
        + builtins.readFile ./config/init.lua;

        # No plugin uses the python or ruby providers.
        withPython3 = false;
        withRuby = false;

        # Servers and tools that packages-development does not provide.
        extraPackages = with pkgs; [
          basedpyright
          ruff
          vscode-langservers-extracted # html, cssls, jsonls
          lldb # lldb-dap, for the nvim-dap C/C++/Rust adapter

          # nvim-treesitter compiles parsers at runtime.
          gnumake
          stdenv.cc
        ];
      };
    };
}

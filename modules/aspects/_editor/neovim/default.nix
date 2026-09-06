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
      # init.lua is deliberately not linked here -- programs.neovim writes
      # nvim/init.lua from `initLua` below, and two writers for that path
      # resolve silently by ordering.
      xdg.configFile = {
        "nvim/lua".source = ./config/lua;
        "nvim/spell".source = ./config/spell;
      };

      # lazy.nvim rewrites its lockfile on `:Lazy update`, so it cannot be a
      # store symlink -- seed it only when absent. After an update, copy the
      # new pins back into the repo:
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

        # Nothing here uses the pynvim or neovim-ruby remote-plugin providers;
        # nvim-dap-python runs debugpy through `uv`.
        withPython3 = false;
        withRuby = false;

        # Servers from custom/configs/lsp.lua that packages-development does
        # not already provide, plus the toolchain plugins shell out to.
        extraPackages = with pkgs; [
          basedpyright
          ruff
          vscode-langservers-extracted # html, cssls, jsonls
          lldb # lldb-dap, for the nvim-dap C/C++/Rust adapter

          # telescope-fzf-native and nvim-treesitter compile at runtime.
          gnumake
          stdenv.cc
        ];
      };
    };
}

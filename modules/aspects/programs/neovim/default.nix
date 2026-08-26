{
  den.aspects.neovim.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.file."./.config/nvim/" = {
        source = ./config;
        recursive = true;
      };

      # lazy.nvim's plugin pins. This cannot go in ./config above: home.file
      # would make it a read-only store symlink, and lazy needs to rewrite it
      # on `:Lazy update`. So seed it only when absent -- a fresh machine gets
      # the committed revisions, an existing one keeps its own.
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
      '';

      programs.neovim = {
        enable = true;
        defaultEditor = true;

        # Adopt the post-26.05 upstream defaults. Nothing here uses the pynvim
        # or neovim-ruby remote-plugin providers -- nvim-dap-python runs
        # debugpy through `uv`, which is unrelated to withPython3.
        withPython3 = false;
        withRuby = false;

        # Everything custom/configs/lsp.lua enables, plus the debug adapter,
        # resolved from nixpkgs rather than mason. Servers already pulled in
        # by packages-development (nil, bash-language-server, ccls, taplo,
        # texlab, tinymist, lua-language-server, millet) are not repeated.
        extraPackages = with pkgs; [
          basedpyright
          ruff
          vscode-langservers-extracted # html, cssls, jsonls
          lldb # lldb-dap, for the nvim-dap C/C++/Rust adapter
        ];
      };
    };
}

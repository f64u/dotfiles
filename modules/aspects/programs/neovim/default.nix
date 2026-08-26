{
  den.aspects.neovim.homeManager =
    { ... }:
    {
      home.file."./.config/nvim/" = {
        source = ./config;
        recursive = true;
      };

      programs.neovim = {
        enable = true;
        defaultEditor = true;

        # Adopt the post-26.05 upstream defaults. Nothing here uses the pynvim
        # or neovim-ruby remote-plugin providers -- nvim-dap-python runs
        # debugpy through `uv`, which is unrelated to withPython3.
        withPython3 = false;
        withRuby = false;
      };
    };
}

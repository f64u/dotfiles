{ ... }:
{
  imports = [
    ./alacritty.nix
    ./ghostty.nix
    ./git.nix
    ./rio.nix
    ./neovim
    ./vscode.nix
    ./starship.nix
    ./tmux.nix
    ./wezterm
    ./zsh.nix
  ];

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
  };
  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  programs.eza = {
    enable = true;
    icons = "auto";
  };
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.lazygit.enable = true;
  programs.nh = {
    enable = true;
  };
  programs.ripgrep.enable = true;
  programs.vim.enable = true;
  programs.zoxide.enable = true;
}

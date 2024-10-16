{ ... }:
{
  imports = [
    ./alacritty.nix
    ./git.nix
    ./neovim
    ./vscode.nix
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
  programs.eza = {
    enable = true;
    icons = "auto";
  };
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.lazygit.enable = true;
  programs.ripgrep.enable = true;
  programs.starship.enable = true;
  programs.vim.enable = true;
  programs.zoxide.enable = true;
}

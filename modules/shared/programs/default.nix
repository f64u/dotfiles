{ ... }:
{
  imports = [
    ./alacritty.nix
    ./git.nix
    ./tmux.nix
    ./zsh.nix
  ];

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
  };
  programs.bat.enable = true;
  programs.eza = {
    enable = true;
    icons = true;
  };
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.lazygit.enable = true;
  programs.ripgrep.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;
}

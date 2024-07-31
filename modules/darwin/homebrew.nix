{ ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    brews = [
      "gmp"
    ];

    casks = [
      "1password"
      "firefox"
      "font-sf-mono"
      "font-sf-pro"
      "minecraft"
      "shottr"
      "smlnj"
      "steam"
      "vmware-fusion"
      "whisky"
    ];

    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
    ];
  };
}

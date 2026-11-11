{ den, ... }:
{
  den.aspects.macbook-pro-work = {
    includes = [
      den.aspects.darwin-nix
      den.aspects.darwin-macos-defaults
      den.aspects.darwin-shells
      den.aspects.darwin-fonts
      den.aspects.darwin-desktop
      den.aspects.darwin-casks
    ];

    darwin = {
      networking.computerName = "Fady's Work MacBook";

      system = {
        stateVersion = 5;
      };
    };

    # This host's default key belongs to the work GitHub account. Personal
    # repos (this one included) use `git@github-personal:f64u/<repo>.git`.
    provides.to-users.homeManager.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings.github-personal = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_personal";
        IdentitiesOnly = true;
      };
    };
  };
}

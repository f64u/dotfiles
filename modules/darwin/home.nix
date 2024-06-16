{ pkgs, ... }:
let
  fullName = "Fady Adal";
  user = "fadyadal";
  email = "2masadel@gmail.com";
in
{
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit fullName user email; };
    users.${user} = { pkgs, config, lib, ... }: {
      imports = [
        ../shared/programs
      ];
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix { inherit pkgs; };
        stateVersion = "23.11";
      };
    };
  };

}

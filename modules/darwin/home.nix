{ ... }:
let
  fullName = "Fady Adal";
  user = "fadyadal";
  uid = 501;
  email = "2masadel@gmail.com";
in
{
  users = {
    knownUsers = [ user ];
    users.${user} = {
      name = "${user}";
      uid = uid;
      home = "/Users/${user}";
      isHidden = false;
      shell = "/bin/zsh";
    };
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

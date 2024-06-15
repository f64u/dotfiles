{ pkgs, lib, ... }:

let user = "fadyadal";
in
{
  users.users.${user} = {
    name = "${user}";
    home = lib.mkMerge [
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "/Users/${user}")
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux "/home/${user}")
    ];
    isHidden = false;
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    users.${user} = { pkgs, config, lib, ... }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix { inherit pkgs; };
        stateVersion = "23.11";
      };
      programs = { } // import ../shared/home.nix { inherit config pkgs lib; };
    };
  };

}

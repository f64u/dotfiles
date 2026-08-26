# Base packages for all systems and users
{
  den.aspects.packages-base.homeManager =
    { pkgs, ... }:
    let
      myPython = pkgs.python313.withPackages (ps: [
        ps.distutils
        ps.flit
        ps.ipython
        ps.numpy
        ps.pandas
        ps.pip
        ps.setuptools
        ps.virtualenv
      ]);
    in
    {
      home.packages = with pkgs; [
        # Core terminal and development tools
        comma
        curl
        dos2unix
        fastfetch
        git
        jq
        wget
        uutils-coreutils-noprefix

        # Common libraries
        openssl
        readline
        ncurses

        # Python
        myPython
        uv

        # Core development
        nodejs
        rustup
      ];
    };
}

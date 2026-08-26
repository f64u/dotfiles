# Base packages for all systems and users.
#
# Everything here is something that should be on PATH in *every* shell. Tools
# that are only wanted occasionally live in packages-heavy instead, which is
# not included by default -- reach for them with `nix shell nixpkgs#<name>` or
# `, <name>` (comma) rather than paying for them in every generation.
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
        # Core terminal tools.
        # NOTE: `git` is not listed here -- programs.git already installs it.
        comma
        curl
        dos2unix
        fastfetch
        jq
        parallel
        wget
        uutils-coreutils-noprefix

        # Wraps bare REPLs with readline. The `sml` / `idris2` shell aliases
        # in the zsh aspect invoke this directly -- don't drop it.
        rlwrap

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

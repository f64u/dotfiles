# Things that should be on PATH in every shell. Occasional tools go in
# packages-heavy instead.
{
  den.aspects.packages-base.homeManager =
    { pkgs, ... }:
    let
      # A REPL with the usual data libraries. Projects and packaging go
      # through uv, so no pip / virtualenv / setuptools here.
      myPython = pkgs.python313.withPackages (ps: [
        ps.ipython
        ps.numpy
        ps.pandas
      ]);
    in
    {
      home.packages = with pkgs; [
        # Core terminal tools.
        comma
        curl
        dos2unix
        jq
        nmap
        parallel
        poppler-utils # pdftoppm, pdftotext, pdfinfo
        # macOS ships no `watch`; this is the procps one.
        watch
        wget
        uutils-coreutils-noprefix
        hyperfine # benchmark commands
        xh # friendlier curl for HTTP APIs

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
        nodejs_24 # Fallback for tools launched outside a mise-activated shell.
        rustup
      ];
    };
}

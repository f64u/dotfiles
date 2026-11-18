# On PATH in every shell. Occasional tools go in packages-heavy.
{
  den.aspects.packages-base.homeManager =
    { pkgs, ... }:
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
        uutils-coreutils-noprefix
        hyperfine # benchmark commands
        xh # friendlier curl for HTTP APIs

        # The `sml` / `idris2` aliases in zsh call this -- don't drop it.
        rlwrap

        # Common libraries
        openssl
        readline
        ncurses

        python313
        uv # Projects, and `uvx ipython` for a REPL.

        # Core development
        nodejs_24 # Fallback for tools launched outside a mise-activated shell.
        rustup
      ];
    };
}

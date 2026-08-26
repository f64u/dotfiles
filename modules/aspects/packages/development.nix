# Development packages.
#
# Language servers, formatters and build tools -- things editors and shells
# expect to find on PATH. Large, occasionally-used SDKs and emulators are in
# packages-heavy instead.
{
  den.aspects.packages-development.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # GUI apps kept here because they are daily drivers; their Electron
        # runtime is shared with vscode, so the marginal cost is small.
        code-cursor
        discord

        # Language servers and tools
        bash-language-server
        ccls
        nil
        nixfmt
        lua-language-server
        taplo # toml
        texlab # latex
        typst
        tinymist # typst
        millet # SML

        # Toolchain managers / REPL support
        elan # Lean
        gh
        lua5_1
        lua51Packages.luarocks
        opam # OCaml

        # LaTeX. `texliveFull` is a 6.4 GiB closure -- it alone was ~46% of the
        # home profile, and dragged in asymptote plus a second Python env with
        # pyqt5. `texliveMedium` covers latexmk, biber and the usual article /
        # beamer / AMS stack. If a build reports a missing .sty, add just that
        # package here rather than going back to Full:
        #
        #   (texliveMedium.withPackages (ps: [ ps.tikz-cd ps.mathpartir ]))
        texliveMedium

        # Build tools
        autoconf
        cmake
        pkg-config
        tree-sitter
      ];
    };
}

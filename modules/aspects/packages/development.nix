# Language servers, formatters and build tools that editors and shells
# expect on PATH. Large SDKs are in packages-heavy.
{
  den.aspects.packages-development.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Language servers and tools
        bash-language-server
        clang-tools # clangd
        nixd
        nixfmt
        lua-language-server
        taplo # toml
        texlab # latex
        typst
        tinymist # typst
        millet # SML

        # CLIs, toolchains and solvers
        awscli2
        elan # Lean
        gh
        lua5_1
        lua51Packages.luarocks
        smlnj
        z3 # SMT solver

        # Not `texliveFull` (6.4 GiB). For a missing .sty, add that package:
        #   (texliveMedium.withPackages (ps: [ ps.tikz-cd ps.mathpartir ]))
        texliveMedium

        # Build tools
        autoconf
        cmake
        pkg-config
        tree-sitter
        just
      ];
    };
}

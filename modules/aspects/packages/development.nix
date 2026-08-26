# Development packages
{
  den.aspects.packages-development.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Advanced development tools
        android-tools
        google-cloud-sdk
        postman
        code-cursor
        discord

        # Language servers and tools
        bash-language-server
        ccls
        languagetool
        nil
        nixfmt
        lua-language-server
        taplo # toml
        texlab # latex
        typst
        tinymist # typst
        millet # SML

        # Specialized tools
        elan
        # fstar
        gh
        lua5_1
        lua51Packages.luarocks
        ollama
        opam
        qemu
        # z3
        texliveFull

        # Build tools
        autoconf
        cmake
        pkg-config
        tree-sitter
      ];
    };
}

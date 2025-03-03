{ ... }:
let
  catppuccin-zsh-syntax-highlighting = builtins.fetchGit {
    url = "https://github.com/catppuccin/zsh-syntax-highlighting.git";
    rev = "7926c3d3e17d26b3779851a2255b95ee650bd928";
  };
in
{
  programs.zsh = {
    enable = true;
    autocd = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initExtra = ''
      export TERM=xterm-256color

      source ~/.ghcup/env
      source ${catppuccin-zsh-syntax-highlighting}/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
      eval $(opam env)
      export PATH=/usr/local/smlnj/bin:$PATH
    '';
    shellAliases = {
      cp = "xcp";
      q = "exit";
      ghci = "TERM=linux ghci";
      stack = "TERM=linux stack";
      idris2 = "rlwrap idris2";
      n = "nvim";
      sml = "rlwrap sml";
    } // (
      let servers = [ "ra" "amun" "set" "anubis" "seshat" "hathor" "thoth" "maat" "sekhmet" ];
      in
      builtins.listToAttrs (map
        (server: {
          name = server;
          value = "ssh fady@${server}.cs.uchicago.edu";
        })
        servers)
    );
  };

}

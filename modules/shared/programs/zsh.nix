{ ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initExtra = ''
      export TERM=xterm-256color

      source ~/.ghcup/env
      eval $(opam env)
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
      let servers = [ "ra" "amun" "set" "anubis" "seshat" "hathor" "thoth" "maat" ];
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

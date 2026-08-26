{ inputs, ... }:
{
  den.aspects.zsh.homeManager =
    { ... }:
    {
      programs.zsh = {
        enable = true;
        autocd = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        initContent = ''
          source ${inputs.catppuccin-zsh-syntax-highlighting}/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh

          # `opam env` shells out to opam on every prompt-less shell start, so
          # only pay for it when opam is actually installed.
          if command -v opam >/dev/null; then
            eval "$(opam env)"
          fi

          export PATH=~/.local/bin:/usr/local/smlnj/bin:$PATH

          function mksudo {
            MINS="''${1:-5}"
            SECS=$(( MINS * 60 ))
            echo Temporarily granting sudo access to $USER for "$MINS"m...
            DOREVOKE="echo Revoking... && dseditgroup -o edit -d $USER -t user admin && echo Revoked."
            DOGRANT="dseditgroup -o edit -a $USER -t user admin && echo Granted."
            su tomasadal -c "sudo bash -c \"trap \\\"$DOREVOKE\\\" EXIT && "$DOGRANT" && sleep $SECS\""
          }

        '';
        shellAliases = {
          q = "exit";
          ghci = "TERM=linux ghci";
          stack = "TERM=linux stack";
          idris2 = "rlwrap idris2";
          n = "nvim";
          sml = "rlwrap sml";
        }
        // (
          let
            servers = [
              "ra"
              "amun"
              "set"
              "anubis"
              "seshat"
              "hathor"
              "thoth"
              "maat"
              "sekhmet"
            ];
          in
          builtins.listToAttrs (
            map (server: {
              name = server;
              value = "ssh fady@${server}.cs.uchicago.edu";
            }) servers
          )
        );
      };

    };
}

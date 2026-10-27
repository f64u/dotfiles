# Personal-machine development packages. Included by macbook-pro, not
# macbook-pro-work -- same split as darwin/casks-personal.nix.
{
  den.aspects.packages-personal.provides.to-users.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # OCaml. zsh runs `opam env` when opam is on PATH (see _shell/zsh.nix),
        # which errors on any machine where `opam init` has never been run.
        opam
      ];
    };
}

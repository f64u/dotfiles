# Personal-machine development packages; macbook-pro only.
{
  den.aspects.packages-personal.provides.to-users.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # OCaml. zsh runs `opam env` when opam is on PATH, which errors where
        # `opam init` was never run.
        opam
      ];
    };
}

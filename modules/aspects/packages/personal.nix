# Personal-machine development packages; macbook-pro only.
{
  den.aspects.packages-personal.provides.to-users.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # OCaml. Projects load their switch with `eval "$(opam env)"` in .envrc.
        opam
      ];
    };
}

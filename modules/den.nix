# Entity declarations: which machines exist, and who lives on them.
#
# Each `den.hosts.<system>.<name>` becomes a darwinConfigurations/nixosConfigurations
# output. The host aspect (den.aspects.<name>) and the user aspect
# (den.aspects.<userName>) are looked up by name — see modules/aspects/.
{ inputs, lib, ... }:
let
  # Identity lives on the user *entity*, readable by any aspect taking
  # `{ user, ... }` (see aspects/programs/git.nix).
  #
  # Not `den.schema.user`: that is merged into every user on every host, so
  # a name and email there become everyone's default.
  fadyadal = {
    fullName = "Fady Adal";
    email = "2masadel@gmail.com";
  };
in
{
  imports = [ inputs.den.flakeModule ];

  den.hosts.aarch64-darwin.macbook-pro.users = { inherit fadyadal; };
  den.hosts.aarch64-darwin.macbook-pro-work.users = { inherit fadyadal; };

  # Every user gets both the lightweight OS `user` class (users.users.<name>)
  # and a home-manager environment.
  den.schema.user.classes = lib.mkDefault [
    "user"
    "homeManager"
  ];
}

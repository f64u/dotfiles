# Entity declarations: which machines exist, and who lives on them.
#
# Each `den.hosts.<system>.<name>` becomes a darwinConfigurations/nixosConfigurations
# output. The host aspect (den.aspects.<name>) and the user aspect
# (den.aspects.<userName>) are looked up by name — see modules/aspects/.
{ inputs, lib, ... }:
let
  # Identity attached to the user *entity*, so any aspect taking `{ user, ... }`
  # can read it (see aspects/programs/git.nix).
  #
  # NOTE: this deliberately does not live in `den.schema.user`. That is a base
  # module merged into every user on every host, so putting a name and email
  # there installs one person's identity as the default for all of them -- and
  # as a non-mkDefault definition, a second user setting their own email gets a
  # merge conflict rather than an override.
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

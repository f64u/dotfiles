# Entity declarations: which machines exist, and who lives on them.
#
# Each `den.hosts.<system>.<name>` becomes a darwinConfigurations/nixosConfigurations
# output. The host aspect (den.aspects.<name>) and the user aspect
# (den.aspects.<userName>) are looked up by name — see modules/aspects/.
{ inputs, lib, ... }:
{
  imports = [ inputs.den.flakeModule ];

  den.hosts.aarch64-darwin.macbook-pro.users.fadyadal = { };
  den.hosts.aarch64-darwin.macbook-pro-work.users.fadyadal = { };
  den.hosts.x86_64-linux.nixos-desktop.users.fadyadal = { };

  # Every user gets both the lightweight OS `user` class (users.users.<name>)
  # and a home-manager environment.
  den.schema.user.classes = lib.mkDefault [
    "user"
    "homeManager"
  ];
}

# Entity declarations: which machines exist, and who lives on them.
#
# Each `den.hosts.<system>.<name>` becomes a darwinConfigurations
# output. The host aspect (den.aspects.<name>) and the user aspect
# (den.aspects.<userName>) are looked up by name — see modules/aspects/.
{ inputs, lib, ... }:
let
  # Identity lives on the user *entity*, readable by any aspect taking
  # `{ user, ... }` (see aspects/_vcs/git.nix).
  #
  # Not `den.schema.user`: that is merged into every user on every host, so
  # a name and email there become everyone's default.
  #
  # `personalEmail` survives the work host's `email` override, so git can
  # still sign this repo's commits with it (see aspects/_vcs/git.nix).
  fadyadal = rec {
    fullName = "Fady Adal";
    email = personalEmail;
    personalEmail = "2masadel@gmail.com";
  };
in
{
  imports = [ inputs.den.flakeModule ];

  # `userName` is the macOS account; `uid` is read by modules/defaults.nix.
  # The aspect stays `fadyadal` on both hosts (den looks it up by the attr
  # name), only the OS-level account differs.
  den.hosts.aarch64-darwin.macbook-pro.users.fadyadal = fadyadal // {
    uid = 501;
  };
  den.hosts.aarch64-darwin.macbook-pro-work.users.fadyadal = fadyadal // {
    userName = "fady";
    uid = 502;
    email = "fady@preludelabs.ai";
    # Commit signing, one SSH key per identity (see aspects/_vcs/git.nix).
    # Each key is registered as a signing key on the matching GitHub account.
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      personalKey = "~/.ssh/id_ed25519_personal.pub";
      allowedSigners = [
        "fady@preludelabs.ai ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKz6u5q1NJekPIXsuKVczE60yrojskpOeoyWP3epHT8o"
        "2masadel@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHxNOI4GpdAjA6ljk+SRzsuViuY5Csd1ElfE8r0iXY6"
      ];
    };
  };

  # Every user gets both the lightweight OS `user` class (users.users.<name>)
  # and a home-manager environment.
  den.schema.user.classes = lib.mkDefault [
    "user"
    "homeManager"
  ];
}

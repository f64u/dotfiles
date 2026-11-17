# Entities: which machines exist and who lives on them. Host and user
# aspects are looked up by name in modules/aspects/.
{ inputs, lib, ... }:
let
  # Identity lives on the user entity (read via aspects/_identities.nix),
  # not `den.schema.user`, which is merged into every user on every host.
  fadyadal = {
    fullName = "Fady Adal";
    # A host's `identity` is its default; the others apply in their `repos`.
    identities = {
      personal = {
        email = "2masadel@gmail.com";
        repos = [ "~/dotfiles" ];
      };
      work.email = "fady@preludelabs.ai";
    };
    identity = "personal";
  };
in
{
  imports = [ inputs.den.flakeModule ];

  # `userName` is the macOS account; the aspect is `fadyadal` on both hosts.
  den.hosts.aarch64-darwin.macbook-pro.users.fadyadal = fadyadal // {
    uid = 501;
  };
  den.hosts.aarch64-darwin.macbook-pro-work.users.fadyadal = fadyadal // {
    userName = "fady";
    uid = 502;
    identity = "work";
    # Public halves of this Mac's Secure Enclave keys (see darwin-secretive),
    # for login and signing. Registered on the matching GitHub account.
    keys = {
      work = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGW1n/fXOvjWAXdwKT1lK3okyn899pxvt2DbotKZgpMLfgm3r1xoKrC6kp/IdzR/TYDuLRPxuGxX59mwDHuHnQM=";
      personal = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKyYazef67Lv0mbXNAt9v/rd7dHDVQ8Z8t0fSvcIFyE4Y83DMnoZuWJaDFcncwJ6W+llARRUTnFYm5QG8qnfaTc=";
    };
    # Old file keys: verify commits before `until` (YYYYMMDD), nothing after.
    retiredKeys = {
      work = [
        {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKz6u5q1NJekPIXsuKVczE60yrojskpOeoyWP3epHT8o";
          until = "20261118";
        }
      ];
      personal = [
        {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHxNOI4GpdAjA6ljk+SRzsuViuY5Csd1ElfE8r0iXY6";
          until = "20261118";
        }
      ];
    };
  };

  # Every user gets an OS account and a home-manager environment.
  den.schema.user.classes = lib.mkDefault [
    "user"
    "homeManager"
  ];
}

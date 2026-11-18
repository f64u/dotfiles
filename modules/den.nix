# Entities: which machines exist and who lives on them. Host and user
# aspects are looked up by name in modules/aspects/.
{ inputs, lib, ... }:
let
  # Shape and derived views: ./schema.nix.
  fadyadal = {
    fullName = "Fady Adal";
    identities = {
      personal = {
        email = "2masadel@gmail.com";
        repos = [ "~/dotfiles" ];
      };
      work.email = "fady@preludelabs.ai";
    };
  };
in
{
  imports = [ inputs.den.flakeModule ];

  # `userName` is the macOS account; the aspect is `fadyadal` on both hosts.
  den.hosts.aarch64-darwin.macbook-pro.users.fadyadal = lib.mkMerge [
    fadyadal
    {
      uid = 501;
      identity = "personal";
    }
  ];
  den.hosts.aarch64-darwin.macbook-pro-work.users.fadyadal = lib.mkMerge [
    fadyadal
    {
      userName = "fady";
      uid = 502;
      identity = "work";
      # This Mac's Secure Enclave keys (see darwin-secretive), each registered
      # on its GitHub account.
      identities.work.key = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGW1n/fXOvjWAXdwKT1lK3okyn899pxvt2DbotKZgpMLfgm3r1xoKrC6kp/IdzR/TYDuLRPxuGxX59mwDHuHnQM=";
      identities.personal.key = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKyYazef67Lv0mbXNAt9v/rd7dHDVQ8Z8t0fSvcIFyE4Y83DMnoZuWJaDFcncwJ6W+llARRUTnFYm5QG8qnfaTc=";
    }
  ];
}

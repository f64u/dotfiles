# `github-<identity>` per identity; plain `github.com` is the host's default.
{ lib, ... }:
{ user, ... }:
let
  ids = import ../_identities.nix lib user;
  pub = id: ".ssh/${id.name}.pub";
in
{
  homeManager =
    { config, ... }:
    let
      host = id: {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/${pub id}";
        IdentitiesOnly = true;
        IdentityAgent = ''"${config.sshAgent.socket}"'';
      };
    in
    {
      imports = [ ./agent.nix ];

      config = lib.mkIf (ids.keyed != [ ]) {
        home.file = lib.listToAttrs (
          map (id: lib.nameValuePair (pub id) { text = id.key + "\n"; }) ids.keyed
        );

        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          settings =
            lib.listToAttrs (map (id: lib.nameValuePair id.githubHost (host id)) ids.keyed)
            // lib.optionalAttrs (ids.primary.key != null) { "github.com" = host ids.primary; };
        };
      };
    };
}

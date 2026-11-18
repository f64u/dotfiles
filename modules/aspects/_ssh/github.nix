# GitHub logins: `github-<identity>` per key, plain `github.com` for the
# host's default.
{ lib, ... }:
{ user, ... }:
let
  alias = id: "github-${id.name}";
  pub = id: ".ssh/${id.name}.pub";
  host = id: {
    HostName = "github.com";
    User = "git";
    IdentityFile = "~/${pub id}";
    IdentitiesOnly = true;
  };
in
{
  homeManager =
    { config, ... }:
    {
      imports = [ ./agent.nix ];

      config = lib.mkIf (user.keyed != [ ]) {
        assertions = [
          {
            assertion = config.sshAgent.socket != null;
            message = "${user.userName} has SSH keys here but the host includes no agent aspect.";
          }
        ];

        home.file = lib.listToAttrs (
          map (id: lib.nameValuePair (pub id) { text = id.key + "\n"; }) user.keyed
        );

        programs.ssh.settings =
          lib.listToAttrs (map (id: lib.nameValuePair (alias id) (host id)) user.keyed)
          // lib.optionalAttrs user.primary.hasKey { "github.com" = host user.primary; };

        # Inside another identity's repos, github.com remotes log in as it.
        programs.git.includes = lib.concatMap (
          id:
          map (repo: {
            condition = "gitdir:${repo}/";
            contents.url."git@${alias id}:".insteadOf = "git@github.com:";
          }) id.repos
        ) (lib.filter (id: id.hasKey) user.scoped);
      };
    };
}

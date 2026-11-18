# One reading of a user's identities (modules/den.nix) for every aspect.
lib: user:
let
  keys = user.keys or { };
  retired = user.retiredKeys or { };
  unknown = lib.attrNames (removeAttrs (keys // retired) (lib.attrNames user.identities));
  all = lib.mapAttrs (
    name: id:
    {
      repos = [ ];
    }
    // id
    // {
      inherit name;
      key = keys.${name} or null;
      retired = retired.${name} or [ ];
      # ssh alias for this identity's GitHub account.
      githubHost = "github-${name}";
    }
  ) user.identities;
in
# A misspelt name would silently turn signing off.
assert lib.assertMsg (
  unknown == [ ]
) "modules/den.nix: keys for unknown identities: ${toString unknown}";
{
  all = lib.attrValues all;
  # The host's default identity.
  primary = all.${user.identity};
  # The rest that name `repos`, each used only inside them.
  scoped = lib.filter (id: id.repos != [ ]) (lib.attrValues (removeAttrs all [ user.identity ]));
  # Those with a key on this host.
  keyed = lib.filter (id: id.key != null) (lib.attrValues all);
}

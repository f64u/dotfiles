# The shape of a user entity; values are in ./den.nix. Aspects read the
# identities, and the views below, off `user`.
{ lib, ... }:
let
  inherit (lib) mkOption types;
  identity = types.submodule (
    { name, config, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
          readOnly = true;
        };
        email = mkOption { type = types.str; };
        repos = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Where the identity applies when it is not the host's default.";
        };
        key = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Public half of this host's key, for login and signing.";
        };
        hasKey = mkOption {
          type = types.bool;
          default = config.key != null;
          readOnly = true;
        };
      };
    }
  );
  # Derived, so read-only; `raw` keeps the identities as already evaluated.
  view =
    default:
    mkOption {
      inherit default;
      type = types.raw;
      readOnly = true;
    };
in
{
  den.schema.user =
    { config, ... }:
    let
      all = lib.attrValues config.identities;
    in
    {
      # An OS account and a home-manager environment.
      config.classes = lib.mkDefault [
        "user"
        "homeManager"
      ];

      options = {
        fullName = mkOption { type = types.str; };
        identities = mkOption { type = types.attrsOf identity; };
        identity = mkOption {
          type = types.enum (lib.attrNames config.identities);
          description = "The host's default identity.";
        };
        primary = view config.identities.${config.identity};
        # The others that name `repos`, each used only inside them.
        scoped = view (lib.filter (id: id.name != config.identity && id.repos != [ ]) all);
        keyed = view (lib.filter (id: id.hasKey) all);
      };
    };
}

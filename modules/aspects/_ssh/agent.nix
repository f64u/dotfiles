# The SSH agent as an option. Imported by path by whoever sets or reads it,
# so no aspect depends on another. `socket` has no default: a host with keys
# must include an agent aspect (darwin-secretive).
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sshAgent = {
    socket = lib.mkOption {
      type = lib.types.str;
      description = "Socket of the agent holding this user's SSH keys.";
    };
    keygen = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "An ssh-keygen that signs through `socket`.";
      # ssh-keygen only finds an agent through the environment.
      default = "${pkgs.writeShellScript "ssh-keygen-agent" ''
        SSH_AUTH_SOCK=${lib.escapeShellArg config.sshAgent.socket} exec ${lib.getExe' pkgs.openssh "ssh-keygen"} "$@"
      ''}";
    };
  };
}

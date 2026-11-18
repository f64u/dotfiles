# The SSH agent as an option: an agent aspect (darwin-secretive) sets
# `socket`, and this makes it the agent for ssh, the shell and signing.
# Imported by path by whoever sets or reads it.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sshAgent;
in
{
  options.sshAgent = {
    socket = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Socket of the agent holding this user's SSH keys.";
    };
    keygen = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "An ssh-keygen that signs through `socket`.";
      # For callers outside a shell, which lack SSH_AUTH_SOCK.
      default = "${pkgs.writeShellScript "ssh-keygen-agent" ''
        SSH_AUTH_SOCK=${lib.escapeShellArg cfg.socket} exec ${lib.getExe' pkgs.openssh "ssh-keygen"} "$@"
      ''}";
    };
  };

  config = lib.mkIf (cfg.socket != null) {
    home.sessionVariables.SSH_AUTH_SOCK = cfg.socket;
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*".IdentityAgent = ''"${cfg.socket}"'';
    };
  };
}

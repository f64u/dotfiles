# Secretive: agent for SSH keys in the Secure Enclave. Keys are created in
# the app, which also registers the agent on first launch.
{
  den.aspects.darwin-secretive.provides.to-users.homeManager =
    { config, pkgs, ... }:
    {
      imports = [ ../_ssh/agent.nix ];

      home.packages = [ pkgs.secretive ];
      sshAgent.socket = "${config.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
    };
}

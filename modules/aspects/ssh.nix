# SSH: which key logs in where. The agent is the host's choice.
{ ... }@args:
{
  den.aspects.ssh.includes = [
    (import ./_ssh/github.nix args)
  ];
}

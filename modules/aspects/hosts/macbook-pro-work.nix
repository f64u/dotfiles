{ den, ... }:
{
  den.aspects.macbook-pro-work = {
    includes = [ den.aspects.darwin-base ];

    darwin = {
      networking.computerName = "Fady's MacBook Air";

      system = {
        defaults.smb.NetBIOSName = "macbook-pro-work";
        stateVersion = 5;
      };
    };
  };
}

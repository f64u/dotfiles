# Bootloader. Assumes UEFI; a BIOS machine would want grub instead.
{
  den.aspects.nixos-boot.nixos = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}

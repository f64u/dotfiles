# Casks for personal machines only.
#
# Included by macbook-pro and NOT by macbook-pro-work. Everything here was
# previously in the shared list, so the work laptop was installing -- and,
# because of `onActivation.cleanup = "zap"`, actively keeping -- a games
# library.
#
# Judgement call worth revisiting: spotify and whatsapp are here rather than
# in the shared list on the grounds that they are personal media and personal
# messaging. Moving either back is a one-line change.
{
  den.aspects.darwin-homebrew-personal.darwin = {
    homebrew.casks = [
      # Games and emulation
      "dolphin" # GameCube / Wii
      "minecraft"
      "nvidia-geforce-now"
      "steam"
      "whisky" # Windows game compatibility layer

      # Personal media / messaging
      "spotify"
      "whatsapp"
    ];
  };
}

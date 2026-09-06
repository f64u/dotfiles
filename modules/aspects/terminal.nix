# Terminal emulator.
{ ... }@args:
{
  den.aspects.terminal.includes = [
    (import ./_terminal/wezterm args)
  ];
}

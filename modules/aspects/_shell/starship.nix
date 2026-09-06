# Prompt. A module of den.aspects.shell.
{ inputs, lib, ... }:
let
  theme = "mocha";
in
{
  homeManager.programs.starship = {
    enable = true;
    # Theme first, our overrides second -- the merge used to run the other
    # way, letting the vendored TOML win over settings stated here.
    settings = lib.importTOML "${inputs.catppuccin-starship}/themes/${theme}.toml" // {
      palette = "catppuccin_${theme}";
    };
  };
}

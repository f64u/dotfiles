{ inputs, ... }:
{
  den.aspects.starship.homeManager =
    { ... }:
    let
      theme = "mocha";
    in
    {
      programs.starship = {
        enable = true;
        settings = {
          palette = "catppuccin_${theme}";
        }
        // builtins.fromTOML (builtins.readFile "${inputs.catppuccin-starship}/themes/${theme}.toml");
      };
    };
}

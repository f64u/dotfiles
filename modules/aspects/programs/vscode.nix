# With no `profiles` set, this module's whole effect is installing the package
# -- nothing is written, so there is no read-only settings.json to fight.
{
  den.aspects.vscode.homeManager.programs.vscode.enable = true;
}

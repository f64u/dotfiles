# What Claude Code should know about this shell (its global instructions).
# A module of den.aspects.shell.
{ ... }:
{
  homeManager.home.file.".claude/CLAUDE.md".source = ./claude-global.md;
}

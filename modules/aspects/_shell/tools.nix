# Shell tools that need `enable` plus a line or two. A module of
# den.aspects.shell.
{ ... }:
{
  homeManager = {
    programs.bat.enable = true;
    programs.btop.enable = true;
    programs.direnv = {
      enable = true;
      # Caches the flake evaluation of a project's .envrc.
      nix-direnv.enable = true;
    };
    programs.eza = {
      enable = true;
      icons = "auto";
    };
    programs.fd.enable = true;
    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };
    programs.fzf = {
      enable = true;
      # Atuin owns Ctrl-R.
      historyWidget.command = "";
    };
    # Per-project tool versions; reads .node-version and .nvmrc too.
    programs.mise = {
      enable = true;
      globalConfig = {
        tools.node = "24";
        settings.idiomatic_version_file_enable_tools = [ "node" ];
      };
    };
    programs.nh.enable = true;
    programs.ripgrep.enable = true;
    programs.zoxide.enable = true;
  };
}

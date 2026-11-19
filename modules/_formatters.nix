# The formatters behind `nix fmt` (./dev.nix) and `jj fix`
# (./aspects/_vcs/jj.nix). Style lives in ../.editorconfig.
pkgs: {
  nixfmt = {
    package = pkgs.nixfmt;
    files = [ "*.nix" ];
    # Arguments that format stdin as the file at `$path`.
    stdin = [ "--filename=$path" ];
  };
  stylua = {
    package = pkgs.stylua;
    files = [
      "*.lua"
      "*sketchybarrc"
    ];
    stdin = [
      "--stdin-filepath=$path"
      "-"
    ];
  };
  shfmt = {
    package = pkgs.shfmt;
    files = [ "*.sh" ];
    inPlace = [ "-w" ];
    stdin = [ "--filename=$path" ];
  };
}

# Editors: neovim as the daily driver, vim as the rescue fallback, vscode for
# the things that only work there.
{ ... }@args:
{
  den.aspects.editor.includes = [
    (import ./_editor/neovim args)
    (import ./_editor/vim.nix args)
    (import ./_editor/vscode.nix args)
  ];
}

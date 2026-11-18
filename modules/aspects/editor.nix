# Editors: neovim daily, vim as the fallback, vscode where needed.
{ ... }@args:
{
  den.aspects.editor.includes = [
    (import ./_editor/neovim args)
    (import ./_editor/vim.nix args)
    (import ./_editor/vscode.nix args)
  ];
}

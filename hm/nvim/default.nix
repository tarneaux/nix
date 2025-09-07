{
  pkgs,
  ...
}:
{
  imports = [
    ./base.nix
    ./extra-mappings.nix
    ./lsp.nix
    ./telescope.nix
    ./tmux.nix
    ./specific.nix
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    package = pkgs.unstable.neovim-unwrapped;
  };
}

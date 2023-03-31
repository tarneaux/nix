{ pkgs, hostname, username, ... }:

{
  imports = [
    ../../${hostname}/home-manager.nix
  ];
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
  };
  programs.home-manager.enable = true;

  programs.git = import ./git.nix { inherit pkgs; };
  programs.zsh = import ./zsh.nix { inherit pkgs; };
  programs.neovim = import ./neovim.nix { inherit pkgs; };
}

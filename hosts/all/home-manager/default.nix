{ pkgs, hostname, username, lib, ... }:

{
  imports = [
    ../../${hostname}/home-manager.nix
  ];
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
    packages = with pkgs; [
      bat # cat clone with syntax highlighting and Git integration. Written in Rust (UwU)
    ];
  };
  programs.home-manager.enable = true;


  programs.git = import ./git.nix { inherit pkgs; };
  programs.zsh = import ./zsh.nix { inherit pkgs; };
  programs.neovim = import ./neovim.nix { inherit pkgs; };
  programs.starship = import ./starship.nix { inherit pkgs lib; };
}

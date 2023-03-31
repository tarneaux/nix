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
      fd # simple, fast and user-friendly alternative to find
      fzf # command-line fuzzy finder
      git # you don't need me to explain what it is, do you?
      ripgrep # grep clone with an eye on speed
      trash-cli # command-line interface to the freedesktop.org Trash
      exa # ls clone with colors and icons. Written in Rust (UwU) too
    ];
  };
  programs.home-manager.enable = true;


  programs.zsh = import ./zsh.nix { inherit pkgs lib; };
  programs.git = import ./git.nix { inherit pkgs; };
  programs.neovim = import ./neovim.nix { inherit pkgs; };
  programs.starship = import ./starship.nix { inherit pkgs lib; };
}

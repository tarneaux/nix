{ pkgs, ... }:
{
  imports = [
    ./lazygit.nix
    ./zsh.nix
    ./tmux.nix
    ./nvim.nix
    ./user.nix
    ./git.nix
    ./gpg.nix
  ];
  programs.fzf.enable = true;
  home.packages = with pkgs; [
    gnumake
    bottom
    glow
    progress
    file
  ];
}

{ pkgs, ... }: {
  imports = [
    ./lazygit.nix
    ./zsh.nix
    ./tmux.nix
    ./nvim.nix
    ./user.nix
    ./git.nix
  ];
  programs.fzf.enable = true;
  home.packages = with pkgs; [
    gnumake
    progress
    file
  ];
}

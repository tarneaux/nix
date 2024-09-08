{ pkgs, ... }: {
  imports = [
    ./lazygit.nix
  ];
  programs.fzf.enable = true;
  home.packages = with pkgs; [
    gnumake
    progress
    file
  ];
}

{ pkgs, ... }: {
  programs.lazygit.enable = true;
  programs.fzf.enable = true;
  home.packages = with pkgs; [
    gnumake
  ];
}

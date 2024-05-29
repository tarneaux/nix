{ pkgs, ... }: {
  imports = [
    ./lazygit.nix
  ];
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
  home.packages = with pkgs; [
    gnumake
  ];
}

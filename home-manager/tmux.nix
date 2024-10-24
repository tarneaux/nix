{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./config/tmux.conf;
    prefix = "C-a";
  };
  home.packages = [
    (pkgs.writeShellApplication {
      name = "__tmux_fzf_window";
      text = builtins.readFile ./config/tmux-fzf-window.sh;
    })
  ];
}

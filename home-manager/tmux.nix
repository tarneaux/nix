{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./config/tmux.conf;
    prefix = "C-a";
  };
  home.packages = [
    (pkgs.writeShellApplication {
      name = "tmw";
      bashOptions = [ ];
      text = builtins.readFile ./config/tmux-fzf-window.sh;
    })
  ];
}

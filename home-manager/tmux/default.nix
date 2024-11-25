{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    prefix = "C-a";
  };
  home.packages = [
    (pkgs.writeShellApplication {
      name = "tmw";
      bashOptions = [ ];
      text = builtins.readFile ./tmux-fzf-window.sh;
    })
  ];
}

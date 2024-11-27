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
      text = builtins.readFile ./tmw.sh;
    })
    (pkgs.writeShellApplication {
      name = "dev";
      text = builtins.readFile ./dev.sh;
    })
  ];
}

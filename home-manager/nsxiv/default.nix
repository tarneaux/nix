{ pkgs, ... }:
{
  home.packages = [ pkgs.nsxiv ];
  home.file.".config/nsxiv/exec/key-handler" = {
    text = builtins.readFile ./key-handler.sh;
    executable = true;
  };
}

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./config/tmux.conf;
  };
}

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set guioptions none
    '';
  };
}

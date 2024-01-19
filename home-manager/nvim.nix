{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}

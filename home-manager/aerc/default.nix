{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aerc
    w3m
  ];
  home.file.".config/aerc" = {
    source = ./config;
    recursive = true;
  };
}

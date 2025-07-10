{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (unison.override { enableX11 = false; })
    unisond
  ];
  home.file.".unison/dotsync.prf".source = ./dotsync.prf;
  home.file.".unison/space.prf".source = ./space.prf;
}

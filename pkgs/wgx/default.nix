# Installation:
# security.wrappers.wgx = {
#   setuid = true;
#   owner = "root";
#   group = "root";
#   source = "${pkgs.wgx}/bin/wgx";
# };

{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "wgx";

  src = pkgs.lib.fileset.toSource {
    root = ./.;
    fileset = ./wgx.c;
  };

  buildPhase = ''
    gcc wgx.c -s -o wgx
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp wgx $out/bin
  '';
}

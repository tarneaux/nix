{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (unison.override { enableX11 = false; })
    (pkgs.writeScriptBin "unison-sync" (builtins.readFile ./config/unison-sync.sh))
  ];
  home.file.".unison/default.prf".source = ./config/unison-default.prf;
}

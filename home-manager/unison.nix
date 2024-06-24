{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (unison.override { enableX11 = false; })
    (pkgs.writeShellApplication {
      name = "unison-sync";
      text = builtins.readFile ./config/unison-sync.sh;
    })
  ];
  home.file.".unison/default.prf".source = ./config/unison-default.prf;
}

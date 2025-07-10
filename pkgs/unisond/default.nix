{ pkgs }:
pkgs.symlinkJoin {
  name = "unisond";
  paths = [
    (pkgs.writeShellApplication {
      name = "unisond";
      text = builtins.readFile ./unisond.sh;
    })
    (pkgs.writeShellApplication {
      name = "unisond-status";
      text = builtins.readFile ./unisond-status.sh;
    })
    (pkgs.writeShellApplication {
      name = "unisond-control";
      text = builtins.readFile ./unisond-control.sh;
    })
  ];
}

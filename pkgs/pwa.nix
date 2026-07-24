{
  pkgs,
}:

{
  url,
  name,
  desktopName ? name,
  icon ? "applications-internet",
}:
let
  script = pkgs.writeShellScriptBin name ''
    exec ${pkgs.chromium}/bin/chromium \
           --app="${url}" \
           --user-data-dir="$HOME/.local/share/webapps/${name}" \
           "$@"
  '';

  desktop = pkgs.makeDesktopItem {
    inherit name icon;
    desktopName = desktopName;
    exec = "${script}/bin/${name}";
    categories = [ "Network" ];
    startupWMClass = name; # helps WM group windows correctly
  };
in
pkgs.symlinkJoin {
  inherit name;
  paths = [
    script
    desktop
  ];
}

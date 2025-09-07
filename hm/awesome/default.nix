{ pkgs, ... }:
{
  imports = [ ../xorg ];
  home.file = {
    ".config/awesome" = {
      source = ./config;
      onChange = ''
        ${pkgs.procps}/bin/pgrep awesome | xargs kill -HUP
      '';
    };
    ".config/lua/lain" = {
      source = pkgs.fetchFromGitHub {
        owner = "lcpz";
        repo = "lain";
        rev = "88f5a8abd2649b348ffec433a24a263b37f122c0";
        hash = "sha256-MH/aiYfcO3lrcuNbnIu4QHqPq25LwzTprOhEJUJBJ7I=";
      };
      onChange = ''
        ${pkgs.procps}/bin/pgrep awesome | xargs kill -HUP
      '';
    };
  };
  home.packages = with pkgs; [
    brightnessctl
    libnotify
    maim
    mpc-cli
    playerctl
    xss-lock
    (writeShellApplication {
      name = "awesomewm-autostart";
      # Gets run every time awesomewm starts or reloads.
      text = # bash
        ''
          # X settings
          xset r rate 300 50
          setxkbmap fr
          xset s 600
          xss-lock --transfer-sleep-lock lock &

          # Daemons & autostart apps
          pgrep -f signal-desktop > /dev/null || signal-desktop --start-in-tray &
          pidof -q blueberry-tray || blueberry-tray &

          # Custom daemons
          pidof -qx autorandr-watcher || autorandr-watcher &
          unisond space &
          unisond dotsync &
          pidof -qx nextcloud-sync || nextcloud-sync &
          pidof -qx space-autocommit || space-autocommit &
        '';
    })
  ];
}

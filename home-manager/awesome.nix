{ pkgs, ... }:
{
  imports = [ ./xorg.nix ];
  home.file = {
    ".config/awesome" = {
      source = ./config/awesome;
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
    (pkgs.writeShellApplication {
      name = "awesomewm-autostart";
      # Gets run every time awesomewm starts or reloads.
      text = # bash
        ''
          # Misc
          xset r rate 300 50 # Also set in bar/widgets/triboard_batt.lua
          setxkbmap fr
          xset s 600

          # Autostart apps
          pgrep signal-desktop > /dev/null || signal-desktop --start-in-tray &
          pgrep blueberry-tray > /dev/null || blueberry-tray &

          # Handle display hotplugs
          pidof -x autorandr-watcher > /dev/null || autorandr-watcher &

          # Lock the screen when it turns off or when going to sleep
          # xss-lock will exit if already running, no need to pgrep.
          xss-lock --transfer-sleep-lock lock &

          # Sync files with my server
          pgrep -l unison | grep -v unison-status > /dev/null || unison-sync &
          pidof -x nextcloud-sync > /dev/null || nextcloud-sync &
        '';
    })
  ];
}

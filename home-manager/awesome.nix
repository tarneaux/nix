{ inputs
, pkgs
, ...
}: {
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
    "./.config/wallpapers" = {
      # Here we fetch from another git repo to prevent cluttering the main repo.
      # This is already defined in the `inputs` attribute, as `wallpapers`.
      source = inputs.wallpapers;
    };
  };
  services.redshift = {
    enable = true;
    temperature = {
      day = 6500;
      night = 4000;
    };
    provider = "geoclue2";
  };
  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 3;
    shadow = true;
    settings = {
      # Prevent the bug where i3lock is shown behind windows, defeating part of
      # its purpose.
      unredir-if-possible = true;
    };
  };
  home.packages = with pkgs; [
    brightnessctl
    i3lock
    libnotify
    maim
    mpc-cli
    playerctl
    xclip
    xorg.xinput
    xorg.xmodmap
    xss-lock
    nextcloud-client
    (pkgs.writeScriptBin "autorandr-watcher" ''
      #!${pkgs.bash}/bin/bash
      # If 2 screens are enabled, which only happens when autorandr hasn't run
      # yet, run it.
      xrandr | grep "*+" | wc -l | grep -q 2 && autorandr --change
      while true; do
        pkill awesome --signal HUP
        pkill qutebrowser --signal HUP
        ${pkgs.inotify-tools}/bin/inotifywait -e modify /tmp/autorandr-current-profile
        # Re-enable internal keyboard in case it was disabled by the user.
        # Useful when forgetting to re-enable it, I just know I'll have
        # forgotten if I plug in a monitor while it's still disabled, since
        # disabling it is useless when I don't have my split keyboard on top of
        # the laptop's.
        xinput enable "AT Translated Set 2 keyboard"
      done
    '')
    (pkgs.writeScriptBin "keyboard-watcher" ''
      #!${pkgs.bash}/bin/bash
      manage() {
        echo "New keyboard detected"
        echo "Sleeping"
        sleep 1
        echo "Waking up, setting options"
        setxkbmap fr
        xset r rate 300 50
      }
      touch /tmp/keyboard
      while true; do
        # /tmp/keyboard is touched by a udev rule whenever a keyboard is plugged
        # in.
        inotifywait /tmp/keyboard
        manage &
      done
    '')
    (pkgs.writeScriptBin "nextcloud-sync" ''
      #!${pkgs.bash}/bin/bash
      pass=$(cat ~/.local/share/nextcloudpass)
      while true; do
        nextcloudcmd -h --user tarneo --password "$pass" --non-interactive --path /renn.es ~/renn.es https://cloud.renn.es
        inotifywait ~/renn.es -t 600
      done
    '')
  ];
}

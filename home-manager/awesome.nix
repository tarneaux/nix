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
    ".config/libinput-gestures.conf" = {
      text = ''
        gesture swipe down awesome-client "require('awful').tag.history.restore (s)"

        gesture swipe left awesome-client "require('awful').tag.viewidx (-1)"
        gesture swipe right	awesome-client "require('awful').tag.viewidx (1)"
      '';
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
    libinput-gestures
    (pkgs.writeShellApplication {
      name = "lock";
      text = builtins.readFile ./config/lock.sh;
    })
    (pkgs.writeShellApplication {
      name = "powermenu";
      text = ''
        action=$(printf 'suspend\nhibernate\nreboot\nshutdown' | dmenu)

        case $action in
            suspend) systemctl suspend;;
            hibernate) systemctl hibernate;;
            reboot) reboot;;
            shutdown) shutdown now;;
        esac
      '';
    })
    (pkgs.writeShellApplication {
      name = "awesomewm-autostart";
      # Gets run every time awesomewm starts or reloads.
      text = /* bash */ ''
        # Misc
        xset r rate 300 50
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

        libinput-gestures
      '';
    })
    (pkgs.writeShellApplication {
      name = "autorandr-watcher";
      text = /* bash */ ''
        reload() {
          pkill awesome --signal HUP
          pkill qutebrowser --signal HUP
          # Re-enable internal keyboard in case it was disabled by the user.
          # Useful when forgetting to re-enable it, I just know I'll have
          # forgotten if I plug in a monitor while it's still disabled, since
          # disabling it is useless when I don't have my split keyboard on top of
          # the laptop's.
          xinput enable "AT Translated Set 2 keyboard"
          # xinput enable "$(xinput list | grep "kanata" | grep -E "(floating slave|keyboard)" | sed -n "s/.*id=\\([0-9]*\\).*/\\1/p")"
        }

        # If 2 screens are enabled, which only happens when autorandr hasn't run
        # yet, run it.
        if [[ $(xrandr | grep -c "\\*\\+") -eq 2 ]]; then
          autorandr --change
          reload
        fi
        while true; do
          ${pkgs.inotify-tools}/bin/inotifywait -e modify /tmp/autorandr-current-profile
          reload
        done
      '';
    })
    (pkgs.writeShellApplication {
      name = "nextcloud-sync";
      text = /* bash */ ''
        pass=$(cat ~/.local/share/nextcloudpass)
        while true; do
          nextcloudcmd -h --user tarneo --password "$pass" --non-interactive --path /renn.es ~/renn.es https://cloud.renn.es
          inotifywait ~/renn.es -t 600
        done
      '';
    })
  ];
}

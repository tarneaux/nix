{ inputs, pkgs, ... }: {
  home.file."./.config/wallpapers".source = inputs.wallpapers;

  services = {
    redshift = {
      enable = true;
      temperature = {
        day = 6500;
        night = 4000;
      };
      provider = "geoclue2";
    };

    picom = {
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
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [ "FantasqueSansM Nerd Font Mono" ];
  };

  home.packages = with pkgs; [
    xclip

    (writeShellApplication {
      name = "lock";
      runtimeInputs = [ xss-lock i3lock ];
      text = builtins.readFile ./config/lock.sh;
    })

    (writeShellApplication {
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


    (writeShellApplication {
      name = "autorandr-watcher";
      runtimeInputs = [ inotify-tools xorg.xinput ];
      text = /* bash */ ''
        reload() {
          pkill awesome --signal HUP
          pkill qutebrowser --signal HUP
          xinput enable "AT Translated Set 2 keyboard"
        }

        # If 2 screens are enabled, which only happens when autorandr hasn't run
        # yet, run it.
        if [[ $(xrandr | grep -c "\\*\\+") -eq 2 ]]; then
          autorandr --change
          reload
        fi
        while true; do
          inotifywait -e modify /tmp/autorandr-current-profile
          reload
        done
      '';
    })

    (writeShellApplication {
      name = "nextcloud-sync";
      runtimeInputs = [ nextcloud-client inotify-tools ];
      text = /* bash */ ''
        pass=$(cat ~/.local/share/nextcloudpass)
        while true; do
          nextcloudcmd -h --user tarneo --password "$pass" --non-interactive --path /renn.es ~/renn.es https://cloud.renn.es
          inotifywait ~/renn.es -t 600
        done
      '';

    })

    (writeShellApplication {
      name = "__enter_risitas_pass";
      runtimeInputs = [ xdotool ];
      text = /* bash */ ''
        if ! [[ $(xdotool getactivewindow getwindowname) =~ risitas@.*:doas ]]; then
          exit 1
        fi
        xdotool keyup super
        gpg --decrypt ~/.risitas.gpg | xdotool type --file -
      '';
    })
  ];
}

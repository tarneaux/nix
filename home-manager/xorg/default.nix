{ inputs, pkgs, ... }:
{
  home.file."./.config/wallpapers".source = inputs.wallpapers;

  services = {
    redshift = {
      enable = true;
      temperature = {
        day = 6500;
        night = 4000;
      };
      latitude = "48.864716";
      longitude = "2.349014";
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

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/about" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
  };

  home.packages = with pkgs; [
    xclip

    (writeShellApplication {
      name = "lock";
      runtimeInputs = [ i3lock ];
      text = builtins.readFile ./lock.sh;
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
      runtimeInputs = [
        inotify-tools
        xorg.xinput
      ];
      text = # bash
        ''
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
      runtimeInputs = [
        nextcloud-client
        inotify-tools
      ];
      text = # bash
        ''
          pass=$(cat ~/.local/share/nextcloudpass)
          while true; do
            nextcloudcmd -h --user tarneo --password "$pass" --non-interactive --path /renn.es ~/renn.es https://cloud.renn.es
            inotifywait ~/renn.es -t 600
          done
        '';

    })

    (writeShellApplication {
      name = "passmenu";
      bashOptions = [ ];
      runtimeInputs = [ xdotool ];
      text = builtins.readFile ./passmenu.sh;
    })
  ];
}

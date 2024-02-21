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
    ".Xmodmap" = {
      source = ./config/Xmodmap;
      onChange = ''
        echo "Reload Xmodmap yourself"
      '';
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
    (pkgs.writeScriptBin "autorandr-watcher" ''
      #!${pkgs.bash}/bin/bash
      while true; do
        ${pkgs.inotify-tools}/bin/inotifywait -e modify /tmp/autorandr-current-profile
        pgrep awesome | xargs kill -s HUP
        pgrep qutebrowser && qutebrowser :config-source
      done
    '')
    (pkgs.writeScriptBin "keyboard-watcher" ''
      #!${pkgs.bash}/bin/bash
      while true; do
        echo "Setting options"
        setxkbmap fr
        xset r rate 300 50
        echo "Waiting for new keyboard"
        udevadm monitor --udev --subsystem-match=hid | sed '/bind/ q' > /dev/null
        echo "Sleeping"
        sleep 1
      done
    '')
  ];
}

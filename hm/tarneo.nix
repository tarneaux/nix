{
  pkgs,
  ugd,
  ...
}:
{
  imports = [
    ./qutebrowser
    ./alacritty
    ./zathura
    ./mpv
    ./mpd
    ./awesome
    ./nsxiv
    ./aerc
    ./rofi
    ./unison
    ./ssh
    ./space
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10" # tmp for bitwarden desktop
  ];

  home.packages = with pkgs; [
    # Command line utilities
    devenv
    dig
    evcxr
    exiftool
    ffmpeg-full
    imagemagick
    inotify-tools
    license-cli
    moreutils
    nmap
    prettier
    openssl
    pamixer
    pandoc
    (pass.override { dmenuSupport = false; })
    podman-compose
    rustc
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-medium
        musixtex
        musixtex-fonts
        songs
        ;
    })
    unzip
    unstable.yt-dlp
    ruff
    pastel
    numbat
    # ugd.packages.x86_64-linux.default
    typst
    gdb
    weechat
    otree

    # X utilities
    bitwarden-desktop
    blueman
    gpick
    hplip
    pavucontrol
    pcmanfm
    qpwgraph
    xkill
    arandr
    gnome-calendar
    evolution-data-server # gnome-calendar dep
    snapshot

    # Full-blown applications
    audacity
    digikam
    inkscape
    kdePackages.kdenlive
    kicad
    libreoffice
    firefox
    nsxiv
    darktable
    rawtherapee
    signal-desktop
    xournalpp
    gimp
    discord
    zapzap
    lmms
  ];
}

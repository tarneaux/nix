{ pkgs, ... }:
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
    nmap
    nodePackages.prettier
    openssl
    pamixer
    pandoc
    (pass.override { dmenuSupport = false; })
    podman-compose
    rustc
    texliveMedium
    unzip
    yt-dlp
    ruff
    pastel
    numbat

    # X utilities
    bitwarden
    blueberry
    gpick
    hplip
    pavucontrol
    pcmanfm
    qpwgraph
    xorg.xkill
    arandr
    gnome-calendar
    evolution-data-server # gnome-calendar dep

    # Full-blown X programs
    audacity
    digikam
    element-desktop
    gnucash
    inkscape
    kdePackages.kdenlive
    kicad
    libreoffice
    librewolf
    firefox
    nsxiv
    obsidian
    rawtherapee
    darktable
    signal-desktop
    xournalpp
    gimp
  ];
}

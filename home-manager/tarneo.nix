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
    ./emacs
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

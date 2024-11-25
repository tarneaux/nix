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
    ./dmenu
    ./unison
  ];

  home.packages = with pkgs; [
    # Command line utilities
    devenv
    dig
    evcxr
    exiftool
    ffmpeg-full
    gh
    hut
    imagemagick
    inotify-tools
    jq
    kubectl
    license-cli
    nmap
    nodePackages.prettier
    openssl
    pamixer
    pandoc
    (pass.override { dmenuSupport = false; })
    podman-compose
    rustc
    texliveSmall
    unzip
    yt-dlp

    # X utilities
    bitwarden
    blueberry
    gpick
    hplip
    pavucontrol
    pcmanfm
    qpwgraph
    xorg.xkill

    # Full-blown X programs
    audacity
    digikam
    element-desktop
    gnucash
    inkscape
    kdenlive
    kicad
    libreoffice
    librewolf
    nsxiv
    obsidian
    rawtherapee
    signal-desktop
    xournalpp
  ];
}

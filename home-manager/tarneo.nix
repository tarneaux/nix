{ pkgs, ... }:
{
  imports = [
    ./qutebrowser.nix
    ./alacritty.nix
    ./zathura.nix
    ./mpv.nix
    ./mpd.nix
    ./awesome.nix
    ./nsxiv.nix
    ./aerc.nix
    ./dmenu.nix
    ./unison.nix
  ];

  home.packages = with pkgs; [
    # Command line utilities
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

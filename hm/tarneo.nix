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
    nodePackages.prettier
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
    ugd.packages.x86_64-linux.default
    typst
    gdb
    weechat

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

    # Full-blown applications
    audacity
    digikam
    inkscape
    kdePackages.kdenlive
    kicad
    libreoffice
    librewolf
    firefox
    nsxiv
    darktable
    signal-desktop
    xournalpp
    gimp
    discord
  ];
}

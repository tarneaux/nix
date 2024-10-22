# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ outputs, pkgs, ... }: {
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
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

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
    pass
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
    rawtherapee
    signal-desktop
    xournalpp
  ];
}

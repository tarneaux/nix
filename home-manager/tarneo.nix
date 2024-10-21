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
    inotify-tools
    texliveSmall
    pandoc
    unzip
    xorg.xkill
    jq
    qpwgraph
    rawtherapee
    kicad
    nmap
    kubectl
    hplip
    libreoffice
    dig
    license-cli
    inkscape
    gpick
    xournalpp
    nodePackages.prettier
    audacity
    kdenlive
    gnucash
    bitwarden
    gh
    evcxr
    rustc
    ffmpeg-full
    blueberry
    digikam
    exiftool
    element-desktop
    imagemagick
    nsxiv
    pamixer
    pavucontrol
    podman-compose
    signal-desktop
    yt-dlp
    pcmanfm
    librewolf
    openssl
    hut
  ];
}

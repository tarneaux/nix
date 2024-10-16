# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ outputs, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
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
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Enable home-manager
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

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/http" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/https" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "x-scheme-handler/about" = [ "org.qutebrowser.qutebrowser.desktop" ];
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
  };
}

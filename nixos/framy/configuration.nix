# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
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
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  #  _  _  _ _/|._    __/__  __/_ _  /_ _  __
  # /_ /_// // //_/ _\ / /_|/ / _\  / //_'//_'
  #             _/

  networking = {
    hostName = "framy";
    networkmanager.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["btrfs"];
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/";
    };
  };

  hardware.enableAllFirmware = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    # font = "FantasqueSansM Nerd Font";
    keyMap = "fr";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+awesome";
      };
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          # lain
        ];
      };
      libinput.enable = true;
      layout = "fr";
    };
    upower.enable = true;
    fprintd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    tlp.enable = true; # Battery saving
  };

  services.logind = {
    lidSwitch = "hibernate";
  };

  security = {
    rtkit.enable = true;
    pam.services.i3lock = {
      # i3lock doesn't support fprintd.
      # Make sure it is disabled, otherwise it will hang.
      fprintAuth = false;
    };
  };

  sound.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs = {
    zsh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bat
    fd
    fzf
    gcc
    git
    gnupg
    htop
    killall
    neovim
    ripgrep
    tmux
    trash-cli
    unstable.eza
    wget
    wireguard-tools
    zoxide
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.tarneo = {
      isNormalUser = true;
      extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        (unison.override {enableX11 = false;})
        aerc
        alacritty
        bitwarden
        bitwarden-cli
        blueberry
        brightnessctl
        digikam
        dmenu
        element-desktop
        i3lock
        imagemagick
        libnotify
        maim
        mpc-cli
        mpd
        mpd-mpris
        ncmpcpp
        nodePackages.bash-language-server
        nodejs-slim
        nsxiv
        ollama
        pamixer
        pavucontrol
        playerctl
        pyright
        signal-desktop
        stow
        texlab # language server for LaTeX (=> md)
        unstable.qutebrowser
        unstable.rustup
        unstable.vscode-langservers-extracted
        vscode-extensions.sumneko.lua
        w3m # For aerc
        xclip
        xorg.xinput
        xorg.xmodmap
        xss-lock
        yaml-language-server
      ];
    };
  };

  nix.settings.trusted-users = ["tarneo"];

  fonts.packages = with pkgs; [
    # fantasque-sans-mono
    (nerdfonts.override {fonts = ["FantasqueSansMono"];})
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

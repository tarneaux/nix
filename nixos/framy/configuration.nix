# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ pkgs, ... }: {
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./autorandr.nix
  ];

  networking.hostName = "framy";

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    kernelParams = [ "amdgpu.sg_display=0" ];
    supportedFilesystems = [ "btrfs" "ntfs" ];
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/";
    };
    # Kernel 6.6 has a bug that prevents the Framework laptop from shutting
    # down: it goes through the halting procedure and then doesn't cut the
    # power. Apparently latest doesn't have that bug anymore.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services = {
    displayManager.defaultSession = "none+awesome";
    xserver = {
      displayManager.lightdm.enable = true;
      enable = true;
      windowManager.awesome = {
        enable = true;
      };
      xkb.layout = "fr";
    };
    libinput.enable = true;
    upower.enable = true;
    fprintd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    fwupd.enable = true; # Firmware/BIOS updates
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
    logind = {
      powerKey = "hibernate";
      lidSwitch = "suspend";
    };
    power-profiles-daemon.enable = true;
    geoclue2.enable = true;
    syncthing = {
      enable = true;
      user = "tarneo";
      dataDir = "/home/tarneo/.sync";
      configDir = "/home/tarneo/.config/syncthing";
    };
    kanata = {
      enable = true;
      package = pkgs.unstable.kanata;
      keyboards = {
        internal = {
          devices = [
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          ];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
            (defsrc
              caps a s d f j k l ;
              lalt
              )
            (defvar
              tap-time 150
              hold-time 200)
            (defalias
              caps esc ;; (tap-hold 100 100 esc (layer-while-held arrows))
              a (tap-hold $tap-time $hold-time a lctl)
              s (tap-hold $tap-time $hold-time s lmet)
              f (tap-hold $tap-time $hold-time f lsft)

              j (tap-hold $tap-time $hold-time j rsft)
              l (tap-hold $tap-time $hold-time l rmet)
              ; (tap-hold $tap-time $hold-time ; rctl)

              lalt (layer-while-held arrows)
            )
            (deflayer default
              @caps @a @s d @f @j k @l @;
              @lalt
            )
            (deflayer arrows
              @caps @a @s d @f left up down right
              @lalt
            )
          '';
        };
      };
    };
    gnome.gnome-keyring.enable = true;
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.tarneo = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "dialout" # For arduino (/dev/ttyACM0 is owned by root:dialout)
      ];
      packages = with pkgs; [
        blueberry
        digikam
        element-desktop
        imagemagick
        nsxiv
        pamixer
        pavucontrol
        podman-compose
        signal-desktop
        stow
      ];
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    containers.registries.search = [
      "docker.io"
    ];
  };

  xdg.mime.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };

  programs.adb.enable = true;

  fonts.packages = with pkgs; [
    # fantasque-sans-mono
    (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

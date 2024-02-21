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
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "amdgpu.sg_display=0" ];
    supportedFilesystems = [ "btrfs" "ntfs" ];
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/";
    };
  };

  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+awesome";
      };
      windowManager.awesome = {
        enable = true;
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
    fwupd.enable = true; # Firmware/BIOS updates
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.tarneo = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        (unison.override { enableX11 = false; })
        blueberry
        digikam
        element-desktop
        imagemagick
        nsxiv
        ollama
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

  fonts.packages = with pkgs; [
    # fantasque-sans-mono
    (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

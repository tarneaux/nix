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
    logind = {
      powerKey = "hibernate";
      lidSwitch = "suspend";
    };
    power-profiles-daemon.enable = true;
    udev.extraRules = ''
      # Touch /tmp/keyboard whenever a keyboard is plugged in
      ACTION=="add", SUBSYSTEM=="input", RUN+="${pkgs.coreutils}/bin/touch /tmp/keyboard"
    '';
    geoclue2.enable = true;
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

# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ pkgs, ... }:
{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./autorandr.nix
  ];

  networking = {
    hostName = "framy";
    firewall.allowedTCPPorts = [ 22000 ];
    firewall.allowedUDPPorts = [
      22000
      21027
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    kernelParams = [ "amdgpu.sg_display=0" ];
    supportedFilesystems = [
      "btrfs"
      "ntfs"
    ];
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/";
    };
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
    syncthing = {
      enable = true;
      user = "tarneo";
      dataDir = "/home/tarneo/.sync";
      configDir = "/home/tarneo/.config/syncthing";
    };
    gnome.gnome-keyring.enable = true;
  };

  # Needed since nixpkgs 25.05 to set SUID and avoid a locked-forever bug.
  programs.i3lock.enable = true;

  security.rtkit.enable = true;

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
        "input"
      ];
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    containers.registries.search = [ "docker.io" ];
  };

  xdg.mime.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };

  fonts.packages = with pkgs; [
    # fantasque-sans-mono
    nerd-fonts.fantasque-sans-mono
    lmodern # For emacs
  ];

  nix.extraOptions = ''
    trusted-users = root tarneo
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ pkgs, config, ... }: {
  imports = [
    ../common.nix
    ../servers.nix
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  networking = {
    hostName = "issou"; # Define your hostname.
    interfaces.enp0s31f6.ipv4.addresses = [
      {
        address = "192.168.1.150";
        prefixLength = 24;
      }
    ];
    defaultGateway.interface = "enp0s31f6";
  };

  users.users.cocinero = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODfULxIav+b+6T/A8f9L+2VKag0+X8dY2Kx92gBxbeu tarneo@framy"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDR89bDo1ZoMGJETAuKd6nMAY+j7KW8kBd2/9ZdYTS1G risitas@cocinero"
    ];
    shell = pkgs.zsh;
  };

  services.btrbk = {
    instances."hdd" = {
      onCalendar = "hourly";
      settings = {
        snapshot_preserve_min = "24h";
        snapshot_preserve = "48h 14d 8w 12m";
        volume = {
          "/mnt/hdd" = {
            subvolume."@bak" = { };
            snapshot_dir = "/mnt/hdd/@snapshots";
          };
        };
      };
    };
  };

  age.secrets = {
    k3s = {
      file = ../../secrets/k3s.age;
      owner = "root";
      group = "root";
    };
  };

  services = {
    k3s = {
      enable = true;
      role = "server";
      tokenFile = config.age.secrets.k3s.path;
      serverAddr = "https://192.168.1.151:6443";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

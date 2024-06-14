# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  custom = {
    restic = {
      enable = true;
      paths = [
        "/data"
        "/home/risitas/services"
        "/btrfs/@data"
      ];
      exclude = [ ];
    };
    networking.ipv4 = {
      lan = "192.168.1.154";
      intra = "10.8.0.2/32";
    };
  };

  services.btrbk = {
    instances."data" = {
      onCalendar = "minutely";
      settings = {
        snapshot_preserve = "14d";
        snapshot_preserve_min = "2d";
        volume."/btrfs/" = {
          snapshot_dir = "/btrfs/@snapshots";
          subvolume = {
            "/btrfs/@data" = { };
          };
        };
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

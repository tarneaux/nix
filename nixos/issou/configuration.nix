# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ pkgs, ... }: {
  imports = [
    ../common.nix
    ../servers.nix
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

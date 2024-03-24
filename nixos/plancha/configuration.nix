# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ config, ... }: {
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
    hostName = "plancha"; # Define your hostname.
    interfaces.eno1.ipv4.addresses = [
      {
        address = "192.168.1.151";
        prefixLength = 16;
      }
    ];
    defaultGateway.interface = "eno1";
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
      clusterInit = true;
      extraFlags = toString [
        "--bind-address=0.0.0.0"
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

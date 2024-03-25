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
    hostName = "gaspacho"; # Define your hostname.
    interfaces.eno1.ipv4.addresses = [
      {
        address = "192.168.1.153";
        prefixLength = 24;
      }
    ];
    defaultGateway.interface = "eno1";
    firewall.allowedTCPPorts = [
      6443 2379 2380 # K3s, etcd
    ];
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

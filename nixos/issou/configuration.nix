# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{...}: {
  imports = [
    ../common.nix
    ../servers.nix
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["btrfs"];

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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

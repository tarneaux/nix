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
      ];
      exclude = [
        "/data/mastodon/public/system/cache/"
        "/data/mastodon/elasticsearch/"
      ];
    };
    networking.ipv4 = {
      lan = "192.168.1.150";
      intra = "10.8.0.3/32";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

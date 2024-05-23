# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ modulesPath, hostname, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  users.users.risitas.initialPassword = "changeme";

  services.openssh.ports = [ 52865 ];

  networking = {
    usePredictableInterfaceNames = false;
    hostName = hostname;
    wg-quick.interfaces.intra = {
      address = [ "10.8.0.1/32" ];
      listenPort = 64468;
      privateKeyFile = "/etc/wireguard/intra.key";
      peers = [
        {
          publicKey = "dz8ILtS9JUmc9dJwrjSUZWfgwN1hjU5fM59Eb333Ojg=";
          allowedIPs = [ "10.8.0.2/32" ];
        }
        {
          publicKey = "Evh0vuKx61wJHVyeAQU+3cpKHIhqheIVRTj2Gua3OnA=";
          allowedIPs = [ "10.8.0.3/32" ];
        }
      ];
    };
    defaultGateway = {
      address = "51.210.176.1";
      metric = 200;
      interface = "eth0";
    };
    nameservers = [ "8.8.8.8" ];

    interfaces.eth0.ipv4.addresses = [
      {
        address = "51.210.180.14";
        prefixLength = 24;
      }
      {
        address = "178.32.110.62";
        prefixLength = 24;
      }
    ];

    nftables = {
      enable = true;
      ruleset = builtins.readFile ./nftables.conf;
    };
  };

  virtualisation.docker.enable = false; # Override default for servers

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  custom.restic.enable = false; # Because there's nothing to back up

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
  nixpkgs.hostPlatform = "x86_64-linux";
}

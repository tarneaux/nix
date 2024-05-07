{ hostname, ipv4_addresses, ... }: {
  networking = {
    # See https://nixos.org/manual/nixos/stable/#sec-rename-ifs
    # TL;DR: Allows using the "eth0" interface name on all hosts
    usePredictableInterfaceNames = false;

    hostName = hostname;

    interfaces.eth0.ipv4.addresses = [
      {
        address = ipv4_addresses.${hostname}.local;
        prefixLength = 24;
      }
    ];

    defaultGateway = {
      address = "192.168.1.1";
      metric = 200;
      interface = "eth0";
    };

    resolvconf.extraConfig = ''
      name_servers_append='192.168.1.1'
      append_search='home'
    '';

    nftables = {
      enable = true;
      ruleset = builtins.readFile ./nftables.conf;
    };

    wg-quick.interfaces = {
      intra = {
        address = [ ipv4_addresses.${hostname}.wg ];
        dns = [ "8.8.8.8" ];
        privateKeyFile = "/etc/wireguard/intra.key";
        peers = [
          {
            publicKey = "5SFZ1w5fWJHJTkiL6LEeBUH6cPh1CFvRVIOuAFxf6k0=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "51.210.180.14:64468";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}

{ hostname, ipv4_addresses, ... }: {
  networking = {
    # See https://nixos.org/manual/nixos/stable/#sec-rename-ifs
    # TL;DR: Allows using the "eth0" interface name on all hosts
    usePredictableInterfaceNames = false;

    hostName = hostname;

    interfaces.eth0.ipv4.addresses = [
      {
        address = ipv4_addresses.${hostname};
        prefixLength = 24;
      }
    ];

    defaultGateway = {
      address = "192.168.1.1";
      metric = 1;
      interface = "eth0";
    };

    resolvconf.extraConfig = ''
      name_servers_append='192.168.1.1'
      append_search='home'
    '';
  };
}

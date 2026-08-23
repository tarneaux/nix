{
  hostname,
  config,
  lib,
  ...
}:
{
  options.custom.networking = {
    ipv4 = {
      lan = lib.mkOption {
        type = lib.types.str;
        description = ''
          Static IPv4 address of this host on eth0.
        '';
      };
      intra = lib.mkOption {
        type = lib.types.str;
        description = ''
          Static IPv4 address of this host on intra.
        '';
      };
    };
  };
  config = {
    networking = {
      # See https://nixos.org/manual/nixos/stable/#sec-rename-ifs
      # TL;DR: Allows using the "eth0" interface name on all hosts
      usePredictableInterfaceNames = false;

      hostName = hostname;

      interfaces.eth0.ipv4.addresses = [
        {
          address = config.custom.networking.ipv4.lan;
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

      wg-quick.interfaces = {
        intra = {
          address = [ config.custom.networking.ipv4.intra ];
          privateKeyFile = "/etc/wireguard/intra.key";
          peers = [
            {
              publicKey = "+9J/cqV6+bGojUdc8huEAUs+jLyknqRTiEbTF0nVRww=";
              allowedIPs = [ "0.0.0.0/0" ];
              endpoint = "51.210.247.8:64468";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };
}

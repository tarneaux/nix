{ ... }:
{
  # See Jake Gines' dotfiles for a dynamic domain block config
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      listen-address = "127.0.0.1";
      server = [
        "178.32.110.62"
        "9.9.9.9"
      ];
    };
  };

  services.resolved.enable = false;
}

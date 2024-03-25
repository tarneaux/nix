{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    jq
    mktemp
    openiscsi
  ];

  networking.firewall.allowedTCPPorts = [
    6443 2379 2380 # K3s, etcd
  ];

  age.secrets = {
    k3s = {
      file = ../secrets/k3s.age;
      owner = "root";
      group = "root";
    };
  };

  services = {
    k3s = {
      enable = true;
      role = "server";
      tokenFile = config.age.secrets.k3s.path;
    };
  };
}

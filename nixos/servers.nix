{ pkgs, inputs, hostname, ipv4_addresses, ... }: {
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

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{
        groups = [ "wheel" ];
        keepEnv = true;
        persist = true;
      }];
    };
    pam.services.su.requireWheel = true;
  };

  users = {
    motd = builtins.readFile ./motd.txt;
    users.risitas = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘doas’ for the user.
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFCEDrSWpY6a/SN1uHCsbGj2ewvnSTSYlx/1Chsk4fsxAAAABHNzaDo= tarneo@framy"
      ];
      packages = [ ];
      shell = pkgs.zsh;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "nixpkgs-unstable"
      "-L"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  environment.systemPackages = [
    inputs.agenix.packages.x86_64-linux.default
  ];

  nix.settings.allowed-users = [ "@wheel" ];
}

{ pkgs, inputs, ... }: {
  networking = {
    defaultGateway = {
      # The interface is configured per-host
      address = "192.168.1.1";
      metric = 1;
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

  users.users.risitas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘doas’ for the user.
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFCEDrSWpY6a/SN1uHCsbGj2ewvnSTSYlx/1Chsk4fsxAAAABHNzaDo= tarneo@framy"
    ];
    packages = [ ];
    shell = pkgs.zsh;
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
}

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
  users.users.risitas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODfULxIav+b+6T/A8f9L+2VKag0+X8dY2Kx92gBxbeu tarneo@framy"
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

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
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
}

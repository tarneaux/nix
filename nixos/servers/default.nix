{ pkgs, inputs, ... }: {
  imports = [
    ./networking.nix
  ];

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

  virtualisation.docker.enable = true;

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

  environment.systemPackages = with pkgs; [
    iptables # For docker to be able to create nftables routes
    inputs.agenix.packages.x86_64-linux.default
  ];

  nix.settings.allowed-users = [ "@wheel" ];
}
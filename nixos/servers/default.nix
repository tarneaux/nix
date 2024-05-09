{ pkgs, inputs, hostname, lib, ... }: {
  imports = [
  ] ++ (if hostname != "chorizo" then [ ./networking.nix ] else [ ]);

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
      linger = true; # Allow using the podman-restart.service without having to log in at reboot
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  virtualisation.docker.enable = lib.mkDefault true;

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

  environment.systemPackages = with pkgs;[
    podman-compose
  ];

  nix.settings.allowed-users = [ "@wheel" ];
}

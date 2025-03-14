{
  pkgs,
  inputs,
  lib,
  agenix,
  ...
}:
{
  imports = [ ./restic.nix ];

  users = {
    motd = builtins.readFile ./motd.txt;
    users.risitas = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘doas’ for the user.
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAf6Onh2VaNjwtlbjtMomJNL72mowcPv+kDtNvPjsrtHAAAAIHNzaDoyMDI1LTAzLTEyLXJlc2lkZW50LW5vdmVyaWZ5 tarneo@framy"
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
      LoginGraceTime = 0;
      StreamLocalBindUnlink = true;
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

  environment.systemPackages = with pkgs; [
    podman-compose
    ctop
    agenix.packages.x86_64-linux.default
  ];

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}

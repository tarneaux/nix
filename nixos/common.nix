{
  pkgs,
  ...
}:
{
  imports = [
    ./boring.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    command-not-found.enable = false;
    zsh.enable = true;
  };

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";

  hardware.enableAllFirmware = true;
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    bat
    fd
    fzf
    gcc
    git
    gnupg
    htop
    killall
    neovim
    ripgrep
    tmux
    trash-cli
    eza
    wireguard-tools
    ncdu
  ];

  # Automatically collect garbage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.allowed-users = [ "@wheel" ];

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          keepEnv = true;
        }
      ];
    };
    pam.services.su.requireWheel = true;
    pam.services.doas.rssh = true;
    pam.rssh = {
      enable = true;
      settings.auth_key_file = "/etc/rssh_authorized_keys";
    };
  };

  environment.etc."rssh_authorized_keys".text = ''
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFSnZa3GIXllDcClXM2toKU0b3r+OL8azbIATlg/Vk9RAAAAB3NzaDpwYW0= tarneo@framy
  '';

  environment.pathsToLink = [ "/share/zsh" ];
}

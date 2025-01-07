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
    unstable.eza
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



}

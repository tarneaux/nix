{ pkgs
, outputs
, inputs
, lib
, config
, ...
}: {
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
  ];

  # ############################ #
  #  Boring flake configuration  #
  # ############################ #
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # Add inputs to the system's legacy channels, to make legacy nix commands
  # consistent with flakes
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
}

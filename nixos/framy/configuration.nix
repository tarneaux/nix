# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{pkgs, ...}: {
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "framy";

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["btrfs"];
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/";
    };
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+awesome";
      };
      windowManager.awesome = {
        enable = true;
      };
      libinput.enable = true;
      layout = "fr";
    };
    upower.enable = true;
    fprintd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    tlp.enable = true; # Battery saving
  };

  services.logind = {
    lidSwitch = "hibernate";
  };

  security = {
    rtkit.enable = true;
    pam.services.i3lock = {
      # i3lock doesn't support fprintd.
      # Make sure it is disabled, otherwise it will hang.
      fprintAuth = false;
    };
  };

  sound.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.tarneo = {
      isNormalUser = true;
      extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        (unison.override {enableX11 = false;})
        aerc
        bitwarden
        bitwarden-cli
        blueberry
        brightnessctl
        digikam
        (dmenu.overrideAttrs {
          src = fetchFromGitHub {
            owner = "tarneaux";
            repo = "dmenu";
            rev = "bab46f0c9f1e8dfc9e19ad26d06bcf3db76f174a";
            sha256 = "sha256-mLViMJlTKw3UXuofFB9LLtVj/vUn+Wp+ZZivbB+Rifk=";
          };
        })
        element-desktop
        i3lock
        imagemagick
        libnotify
        maim
        mpc-cli
        nsxiv
        ollama
        pamixer
        pavucontrol
        playerctl
        podman
        podman-compose
        signal-desktop
        stow
        unstable.qutebrowser
        unstable.rustup
        unstable.vscode-langservers-extracted
        vscode-extensions.sumneko.lua
        w3m # For aerc
        xclip
        xorg.xinput
        xorg.xmodmap
        xss-lock
      ];
    };
  };

  fonts.packages = with pkgs; [
    # fantasque-sans-mono
    (nerdfonts.override {fonts = ["FantasqueSansMono"];})
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

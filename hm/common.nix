{
  pkgs,
  outputs,
  ...
}:
{
  imports = [
    ./lazygit
    ./zsh
    ./tmux
    ./nvim
    ./user
    ./git
    ./gpg
  ];
  programs.fzf.enable = true;
  home.packages = with pkgs; [
    gnumake
    bottom
    glow
    progress
    file
    onefetch
    zip
    treefmt
    dust
    jq
    nmap
    openssl
    eva
    lnav
    toilet
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Minimum viable configurations for home manager
  programs.home-manager.enable = true;
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

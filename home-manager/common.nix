{ pkgs, outputs, ... }:
{
  imports = [
    ./lazygit.nix
    ./zsh.nix
    ./tmux.nix
    ./nvim.nix
    ./user.nix
    ./git.nix
    ./gpg.nix
  ];
  programs.fzf.enable = true;
  home.packages = with pkgs; [
    gnumake
    bottom
    glow
    progress
    file
  ];

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

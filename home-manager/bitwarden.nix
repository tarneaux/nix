{ pkgs, ... }: {
  home.packages = with pkgs; [
    bitwarden
    bitwarden-cli
  ];
  # TODO: bwmenu script
}

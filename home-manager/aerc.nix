{pkgs, ...}: {
  home.packages = [pkgs.aerc];
  home.file.".config/aerc" = {
    source = ./config/aerc;
    recursive = true;
  };
}

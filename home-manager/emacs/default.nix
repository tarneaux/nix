{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = (
      pkgs.emacsWithPackagesFromUsePackage {
        config = ./config.org;

        defaultInitFile = true;

        package = pkgs.emacs-unstable;

        alwaysTangle = true;
        alwaysEnsure = true;
      }
    );
  };
}

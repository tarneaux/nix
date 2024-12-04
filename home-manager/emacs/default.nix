{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = (
      pkgs.emacsWithPackagesFromUsePackage {
        config = ./config.el;

        defaultInitFile = true;

        package = pkgs.emacs-unstable;

        alwaysTangle = true;
        alwaysEnsure = true;
      }
    );
  };
  # TODO: Emacs service
}

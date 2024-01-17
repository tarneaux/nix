{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "tarneo";
    userEmail = "tarneo@tarneo.fr";
    signing = {
      key = null; # Let GPG decide
      signByDefault = true;
    };
    extraConfig = {
      credential.helper = "store";
    };
  };
}

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  home.file = {
    ".config/awesome" = {
      source = ./config/awesome;
      onChange = ''
        ${pkgs.awesome}/bin/awesome-client "awesome.restart()"
      '';
    };
    "./.config/wallpapers" = {
      # Here we fetch from another git repo to prevent cluttering the main repo.
      # This is already defined in the `inputs` attribute, as `wallpapers`.
      source = inputs.wallpapers;
    };
  };
}

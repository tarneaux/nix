{
  inputs,
  pkgs,
  ...
}: {
  home.file = {
    ".config/awesome" = {
      source = ./config/awesome;
      onChange = ''
        ${pkgs.procps}/bin/pgrep awesome | xargs kill -HUP
      '';
    };
    "./.config/wallpapers" = {
      # Here we fetch from another git repo to prevent cluttering the main repo.
      # This is already defined in the `inputs` attribute, as `wallpapers`.
      source = inputs.wallpapers;
    };
  };
}
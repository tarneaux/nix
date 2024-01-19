{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
}

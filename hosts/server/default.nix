{ system, pkgs, lib, home-manager, configuration, ... }:

let
  username = "user";
  hostname = "server";
in lib.nixosSystem rec {
  inherit system;
  specialArgs = { inherit username hostname; };
  modules = [
    configuration
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = import ../all/home-manager {
        inherit pkgs hostname username;
        config = configuration;
      };
    }
  ];
}

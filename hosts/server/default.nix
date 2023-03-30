{ system, pkgs, lib, home-manager, configuration, ... }:

let
  username = "user";
  host = "server";
in lib.nixosSystem {
  inherit system;
  specialArgs = { inherit username host; };
  modules = [
    configuration
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = {
        imports = [ ./home-manager.nix ];
      };
    }
  ];
}
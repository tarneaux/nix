{ system, pkgs, lib, home-manager, ... }:

let
  username = "max";
in lib.nixosSystem {
  inherit system;
  specialArgs = { inherit username; };
  modules = [
    ../configuration.nix
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = {
        imports = [ ./home-manager.nix ];
      };
    }
  ];
}

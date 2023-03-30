{ lib, home-manager, ... }:

let
  username = "user";
  hostname = "server";
in lib.nixosSystem {
  specialArgs = { inherit username hostname; };
  modules = [
    ../all/configuration.nix
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = import ../all/home-manager {
        inherit hostname username;
      };
    }
  ];
}

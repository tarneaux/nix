{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github.com:nixos/nixpkgs/22.11";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      # if you want absolutely proprietary packages
      # config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      server-test = lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
      };
    };
  };
}

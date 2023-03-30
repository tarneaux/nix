{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      # Set this to true if you want absolutely proprietary packages
      config.allowUnfree = false;
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      server = import ./hosts/server {
        inherit pkgs lib home-manager;
      };
    };
  };
}

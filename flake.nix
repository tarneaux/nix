{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github.com:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      # if you want absolutely proprietary packages
      # config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      server-test = lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
      };
    };
  };
}

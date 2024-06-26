{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Wallpaper repo
    wallpapers.url = "github:tarneaux/wallpapers-small";

    # Automated partitioning for some hosts
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Secret storage
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = ""; # Don't download darwin deps
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , disko
    , agenix
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      server_hostnames = [ "issou" "gaspacho" "chankla" "chorizo" ];
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        framy = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/framy/configuration.nix
          ];
        };
      } // nixpkgs.lib.genAttrs server_hostnames (hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs hostname agenix;
          };
          modules = [
            ./nixos/${hostname}/configuration.nix
            ./nixos/common.nix
            ./nixos/servers
            agenix.nixosModules.default
          ] ++ (if (hostname == "chorizo") then [
            disko.nixosModules.disko
          ] else [ ]);
        });

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "tarneo@framy" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
            hostname = "framy";
            username = "tarneo";
          };
          modules = [
            ./home-manager/tarneo.nix
          ];
        };
      } // nixpkgs.lib.genAttrs (map (hostname: "risitas@${hostname}") server_hostnames) (hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs hostname;
            username = "risitas";
          };
          modules = [
            ./home-manager/risitas.nix
          ];
        });
    };
}

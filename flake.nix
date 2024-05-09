{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Wallpaper repo
    wallpapers.url = "github:tarneaux/wallpapers-small";

    # Automated partitioning for some hosts
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , disko
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

      # Define IP addresses for servers.
      ipv4_addresses = {
        issou = {
          local = "192.168.1.150";
          wg = "10.8.0.3/32";
        };
        gaspacho = {
          local = "192.168.1.153";
          wg = "10.8.0.4/32";
        };
        chankla = {
          local = "192.168.1.154";
          wg = "10.8.0.2/32";
        };
        chorizo = {
          primary = "51.210.180.14";
          secondary = "178.32.110.62";
          wg = "10.8.0.1/32";
        };
      };
      server_hostnames = builtins.attrNames ipv4_addresses;
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
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
            inherit inputs outputs hostname ipv4_addresses;
          };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/${hostname}/configuration.nix
            ./nixos/common.nix
            ./nixos/servers
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
            # > Our main home-manager configuration file <
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

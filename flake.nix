{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Automated partitioning for some hosts
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Secret storage
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = ""; # Don't download darwin deps

    # Ultimate Guitar Downloader
    ugd.url = "github:tarneaux/ugd";
    ugd.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      agenix,
      ugd,
      ...
    }@inputs:
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

      server_hostnames = [
        "issou"
        "gaspacho"
        "chorizo"
      ];
    in
    {
      formatter = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.writeShellApplication {
          name = "formatter";
          runtimeInputs = with pkgs; [
            treefmt
            nixfmt-rfc-style
            stylua
            shfmt
            ruff
          ];
          text = "${pkgs.treefmt}/bin/treefmt";
        }
      );
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        framy = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/framy/configuration.nix
          ];
        };
      }
      // nixpkgs.lib.genAttrs server_hostnames (
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              hostname
              agenix
              ;
          };
          modules = [
            ./nixos/${hostname}/configuration.nix
            ./nixos/common.nix
            ./nixos/servers
            agenix.nixosModules.default
          ]
          ++ (
            if (hostname == "chorizo") then [ disko.nixosModules.disko ] else [ ./nixos/servers/networking.nix ]
          );
        }
      );

      homeConfigurations =
        let
          makeUser =
            user_at_host: is_server:
            let
              user_and_host = nixpkgs.lib.strings.splitString "@" user_at_host;
              username = builtins.elemAt user_and_host 0;
              hostname = builtins.elemAt user_and_host 1;
            in
            home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              extraSpecialArgs = {
                inherit
                  inputs
                  outputs
                  is_server
                  user_at_host
                  username
                  hostname
                  ugd
                  ;
              };
              modules = [
                ./user/common.nix
                ./user/${username}.nix
              ];
            };
        in
        {
          "tarneo@framy" = (makeUser "tarneo@framy" false);
        }
        // nixpkgs.lib.genAttrs (map (hostname: "risitas@${hostname}") server_hostnames) (
          user_at_host: makeUser user_at_host true
        );
    };
}

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

    # Emacs overlay
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      agenix,
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
        system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
      );
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations =
        {
          framy = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs outputs;
            };
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
            modules =
              [
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
            home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              extraSpecialArgs =
                let
                  user_and_host = nixpkgs.lib.strings.splitString "@" user_at_host;
                in
                {
                  inherit
                    inputs
                    outputs
                    is_server
                    user_at_host
                    ;
                  username = builtins.elemAt user_and_host 0;
                  hostname = builtins.elemAt user_and_host 1;
                };
              modules = [ ./home-manager ];
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

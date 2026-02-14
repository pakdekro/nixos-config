{
  description = "Mon NixOS de Pentester - Stable Edition";

  inputs = {
    # On verrouille sur la version stable actuelle
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Home Manager doit suivre la même branche (release-25.11)
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix suit aussi les releases pour garantir que les options existent
    stylix.url = "github:danth/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs: {
    nixosConfigurations = {
      # Remplace 'mon-pc' par ton hostname
      radium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.pak = import ./home.nix;
          }
        ];
      };
    };
  };
}

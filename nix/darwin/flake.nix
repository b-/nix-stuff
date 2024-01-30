{
  description = "Nix for macOS configuration";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      # Query the official cache first, and then the mirror of USTC.
      "https://cache.nixos.org"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # Package sets
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    nixpkgs-darwin.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    # home-manager, used for managing user configuration
    home-manager = {
      #url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # Other sources
    #comma = { url = github:nix-community/comma; flake = false; };
    comma = { url = github:nix-community/comma; flake = true; };

  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs =
    inputs @ { self
    , nixpkgs
    , darwin
    , home-manager
    , ...
    }:
    let
      username = "bri";
      system = "x86_64-darwin"; # aarch64-darwin or x86_64-darwin
      hostname = "${username}-macbook";
      specialArgs =
        inputs
        // {
          inherit username hostname;
        };
      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = { allowUnfree = true; };
        #         overlays = attrValues self.overlays ++ singleton (
        #           # Sub in x86 version of packages that don't build on Apple Silicon yet
        #           final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        #             inherit (final.pkgs-x86)
        #               idris2
        #               nix-index
        #               niv
        #               purescript;
        #           })
        #         );
      };
    in
    {
      darwinConfigurations."${hostname}" = darwin.lib.darwinSystem rec {
        inherit system specialArgs;
        modules = [
          ./modules/nix-core.nix
          ./modules/system.nix
          ./modules/apps.nix

          ./modules/host-users.nix
          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bri = import ./modules/home.nix;
          }
        ];
      };
      # nix code formatter
      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    };

  # Overlays --------------------------------------------------------------- {{{

  # overlays = {
  #   # Overlays to add various packages into package set
  #   comma = final: prev: {
  #     comma = import inputs.comma { inherit (prev) pkgs; };
  #   };

  #   ## Overlay useful on Macs with Apple Silicon
  #   #apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
  #   #  # Add access to x86 packages system is running Apple Silicon
  #   #  pkgs-x86 = import inputs.nixpkgs-unstable {
  #   #    system = "x86_64-darwin";
  #   #    inherit (nixpkgsConfig) config;
  #   #  };
  #   #};
  # };

}

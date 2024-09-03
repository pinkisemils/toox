{
  description = "A flake for tools I want to use across multiple platforms, not just nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, nixpkgs,  nixvim, ... }:
    # Now eachDefaultSystem is only using ["x86_64-linux"], but this list can also
    # further be changed by users of your flake.
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        packages = rec {
          nvim = pkgs.callPackage ./nvim/pkg.nix { inherit nixvim; } ;
        };
        nixosModules.tmux = {pkgs, ...}: {


        };
      });
}

{ pkgs, nixvim, ... }: pkgs.callPackage ./pkg.nix { inherit nixvim; }

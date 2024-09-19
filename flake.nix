{
  description = "A flake for tools I want to use across multiple platforms, not just nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    devshell.url = "github:numtide/devshell";
    rust-overlay.url = "github:oxalica/rust-overlay";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, nixpkgs, nixvim, rust-overlay, devshell, ... }:
    # Now eachDefaultSystem is only using ["x86_64-linux"], but this list can also
    # further be changed by users of your flake.
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        packages = rec {
          nvim = pkgs.callPackage ./nvim/pkg.nix { inherit nixvim; };
        };
        nixosModules.tmux = { pkgs, ... }: { };

        devShells.rust =
          let
            overlays = [ (import rust-overlay) ];
            pkgs = import nixpkgs { inherit overlays; inherit system; };
            rust = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
              extensions = [ "rust-src" "rust-analysis" ];
              # targets = [ "aarch64-linux-android" ];
            });

          in
          with pkgs; mkShell {
            name = "rust-shell";

            buildInputs = [

              alsa-lib
              alsa-lib.dev
              rust
              # rust.cargo
              # rust.rustc
              # rust.rust-analyzer-wrapped
              rust-analyzer

              # libs for electron
              electron
              ffmpeg-full
              libmnl
              libnftnl
              dbus
              dbus.out
              # dbus_tools
              openssl
              elfinfo
              libelf

              pkg-config
              clang
              gdb
              gnumake
              binutils

              makeWrapper

              #wireguard build deps
              go
              gopls

              #nodejs build deps
              nodejs
              nodePackages.typescript-language-server
              grpc-tools


              # misc build deps
              openvpn
              git
              curl
              commonsCompress
              p7zip
              fpm
              which

              gcc
              zlib
              libcxx
              lzo


              #remote sshfs
              lsh

              #grpc
              protobuf

              freetype
              python3
              cmake
              libxkbcommon
              xorg.libX11

              llvmPackages.libclang
              llvmPackages.libcxxClang
              clang

            ];

            allowUnfree = true;

            PROTOC = "${protobuf}/bin/protoc";
            GRPC_TOOLS = "${grpc-tools}/bin/grpc_node_plugin";
            LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
            BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion clang}/include";
            shellHook = ''
              export RUST_SRC_PATH="${rust}/lib/rustlib/src/rust/library";
              export PROTOC="${protobuf}/bin/protoc";
              export GRPC_TOOLS="${grpc-tools}/bin/grpc_node_plugin";
              zsh
            '';

          };
      });
}

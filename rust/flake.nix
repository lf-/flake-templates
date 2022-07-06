{
  description = "Example rust project";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
          {
            packages = rec {
              rust-sample = pkgs.rust-sample;
              default = rust-sample;
            };
            checks = self.packages.${system};

            # for debugging
            # inherit pkgs;

            devShells.default = pkgs.rust-sample.overrideAttrs (
              old: {
                # make rust-analyzer work
                RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;

                # any dev tools you use in excess of the rust ones
                nativeBuildInputs = old.nativeBuildInputs ++ (
                  with pkgs; [
                    cargo-insta
                  ]
                );
              }
            );
          }
    )
    // {
      overlays.default = (
        final: prev:
          let
            inherit (prev) lib;
          in
            {
              rust-sample = final.rustPlatform.buildRustPackage {
                pname = "rust-sample";
                version = "0.1.0";

                cargoLock = {
                  lockFile = ./Cargo.lock;
                };

                src = ./.;

                # tools on the builder machine needed to build; e.g. pkg-config
                nativeBuildInputs = with final; [];

                # native libs
                buildInputs = with final; [];
              };
            }
      );
    };
}

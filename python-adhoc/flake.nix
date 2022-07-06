{
  description = "Python devShell-only flake showing adding stuff to the dev shell and overriding python packages";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      out = system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [self.overlays.default];
          };

          # packages that should appear in the python env
          withPackages = with pkgs; python3.withPackages (
            p: with p; [
              pandas
              jupyter
              jupyterlab
            ]
          );
        in
          {
            # tools that should be added to the shell
            devShell = withPackages.env.overrideAttrs (
              old: {
                buildInputs = [ pkgs.graphviz ];
              }
            );

          };
    in
      flake-utils.lib.eachDefaultSystem out // {
        overlays.default = final: prev: {
          python3 = prev.python3.override {
            packageOverrides = pyfinal: pyprev: {
              jupyterlab_server = pyprev.jupyterlab_server.overridePythonAttrs (
                old: {
                  doCheck = false;
                }
              );
            };
          };
        };
      };

}

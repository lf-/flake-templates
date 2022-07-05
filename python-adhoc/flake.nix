{
  description = "Python devShell-only flake showing adding stuff to the dev shell and overriding python packages";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    let out = system:
      let
        overlay = final: prev: {
          python3 = prev.python3.override {
            packageOverrides = pyfinal: pyprev: {
              jupyterlab_server = pyprev.jupyterlab_server.overridePythonAttrs (old: {
                doCheck = false;
              });
            };
          };
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [overlay];
        };
        withPackages = with pkgs; python3.withPackages (p: with p; [
          pandas
          jupyter
          jupyterlab
        ]);
      in
      {
        devShell = withPackages.env.overrideAttrs (old: {
          buildInputs = [pkgs.graphviz];
        });

      }; in with utils.lib; eachSystem defaultSystems out;

}

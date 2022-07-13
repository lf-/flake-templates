{
  description = "Jade's flake templates";

  outputs = { self }:
    let
      mkTemplate = p:
        let
          flake = import (p + "/flake.nix");

          flakeNixPred = path: type:
            type == "regular" && builtins.baseNameOf path == "flake.nix";
        in
          {
            name = builtins.baseNameOf p;
            value = {
              inherit (flake) description;
              path = p;
              flakeNix = {
                description = "flake.nix - ${flake.description}";
                path = builtins.filterSource flakeNixPred p;
              };
            };
          };
    in
      {
        templates =
          builtins.listToAttrs (
            builtins.map mkTemplate [
              ./haskell
              ./python-adhoc
              ./yarn
              ./rust
            ]
          );
      };
}

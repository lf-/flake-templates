{
  description = "Jade's flake templates";

  outputs = { self }:
    let
      mkTemplate = p:
        let
          flake = import (p + "/flake.nix");
        in
          {
            name = builtins.baseNameOf p;
            value = {
              inherit (flake) description;
              path = p;
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

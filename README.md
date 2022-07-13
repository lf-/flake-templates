# Jade's flake templates

This is a set of templates using flake-utils and Opinions.

Current list:

- Rust
- Haskell
- python-adhoc: some packages in a shell
- yarn: just the package manager. actually building packages is TODO and
  mildly horrifying

## Usage

```
# init the entire project
nix flake init -t github:lf-/flake-templates#rust

# only the flake.nix file, in case you are converting an existing project
nix flake init -t github:lf-/flake-templates#rust.flakeNix
```

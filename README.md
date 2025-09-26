My own collection of [Nix](https://nixos.org) expressions.

# Usage

This repo only has a `flake.nix` file so that flake users can add it
as an input. The `flake.nix` is actually empty. This repo does *not*
depend on nixpkgs itself.

To use packages from this repo, you have to use `pkgs.callPackage`
on each `package.nix` yourself. Where you do that is up to you.

For example, to add this into a NixOS configuration, you can apply an
overlay onto your own nixpkgs:

```nix
# Assuming this is in a flake-based config, where "inputs" is all the
# flake inputs you have.
#
# Assuming "nttpkgs" is the name of the flake input that points to this
# repo, ie. you have in your flake.nix:
#
# {
#   inputs = {
#     nttpkgs.url = "github:nttis/nttpkgs";
#   };
# }
#
{inputs, ...}:
{
  imports = [];

  nixpkgs.overlays = [
    (final: prev: final.lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage newScope;
      directory = "${inputs.nttpkgs}/packages";
    })
  ];
}
```

Then, you can use packages from this repo like so:

```nix
{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.tree-sitter-luau # For example
  ];
}
```

# License

All code under this repo is licensed under the [MIT License](LICENSE).

**Note**: the license only applies to code directly present in this
repo. Artifacts built from the Nix expressions are governed by their
own respective upstream license(s).

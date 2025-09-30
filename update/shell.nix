let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  packages = with pkgs; [
    nix-update

    python3
    python313Packages.python-lsp-server
    python313Packages.pylsp-mypy
  ];
}

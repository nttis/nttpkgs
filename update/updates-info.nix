let
  pkgs = import <nixpkgs> { };

  lib = pkgs.lib;

  tree = lib.packagesFromDirectoryRecursive {
    inherit (pkgs) callPackage newScope;
    directory = ../packages;
  };

  treeFiltered = lib.filterAttrs (k: v: lib.isDerivation v) tree;

  updatesInfo = builtins.mapAttrs (k: v: {
    pname = v.pname;
    args = (v.passthru.nixUpdateArgs or [ ]);
  }) treeFiltered;
in
updatesInfo

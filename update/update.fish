#!/usr/bin/env -S nix shell nixpkgs#fish nixpkgs#bubblewrap --command fish

echo "NOTE: This script should be run from the root of the repository, NOT from 'update'."

set root (pwd)
set nixpkgs_root (nix eval --impure --expr 'builtins.toPath <nixpkgs>' | xargs echo)
set dest_dir (mktemp -d)
set work_dir (mktemp -d)

set children (ls packages)
set packages_names (printf "[%s]" (printf ' \"%s\" ' $children))

# We use bubblewrap to overlay the nixpkgs root and our own root on top of each other,
# essentially creating a version of the nixpkgs source tree that has our own packages inside it.
# This allows us to reuse the update infrastructure already present in nixpkgs.

set tmp_root (mktemp -d)
mkdir -p $tmp_root/pkgs/by-name
cp -r $root/packages $tmp_root/pkgs/by-name/nttpkgs

bwrap \
    --bind / / \
    --dev-bind /dev /dev \
    --overlay-src $nixpkgs_root \
    --overlay-src $root \
    --overlay-src $tmp_root \
    --overlay $dest_dir $work_dir $dest_dir \
    --chdir $dest_dir \
    nix-shell "maintainers/scripts/update.nix" \
    --arg keep-going true \
    --arg skip-prompt true \
    --arg predicate "path: pkg: builtins.elem (builtins.elemAt path 0) $packages_names"

# copy back the differences
if test -e $dest_dir/pkgs/by-name/nttpkgs
    cp -r $dest_dir/pkgs/by-name/nttpkgs/* $root/packages
end

rm -r $dest_dir
rm -r $tmp_root

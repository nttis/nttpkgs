#!/usr/bin/env -S nix shell nixpkgs#bubblewrap --command bash

set -eu -o pipefail

echo "NOTE: This script should be run from the root of the repository, NOT from 'update'."

root="$(pwd)"
nixpkgs_root="$(nix eval --impure --expr 'builtins.toPath <nixpkgs>' | xargs echo)"
dest_dir="$(mktemp -d)"
work_dir="$(mktemp -d)"

# We use bubblewrap to overlay the nixpkgs root and our own root on top of each other,
# essentially creating a version of the nixpkgs source tree that has our own packages inside it.
# This allows us to reuse the update infrastructure already present in nixpkgs.

tmp_root="$(mktemp -d)"
mkdir -p "$tmp_root/pkgs/by-name"
cp -r "$root/packages" "$tmp_root/pkgs/by-name/nttpkgs"

bwrap \
  --bind / / \
  --dev-bind /dev /dev \
  --overlay-src "$nixpkgs_root" \
  --overlay-src "$root" \
  --overlay-src "$tmp_root" \
  --overlay "$dest_dir" "$work_dir" "$dest_dir" \
  --chdir "$dest_dir" \
  nix-shell "maintainers/scripts/update.nix" \
  --arg "keep-going" "true" \
  --arg "skip-prompt" "true" \
  --argstr "path" "" \

# copy back the differences
if [ -e "$dest_dir"/pkgs/by-name/nttpkgs ]; then
  cp -r "$dest_dir"/pkgs/by-name/nttpkgs/* "$root/packages"
fi

rm -r "$dest_dir"
rm -r "$tmp_root"

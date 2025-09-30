#!/usr/bin/env -S nix shell nixpkgs#nix-update nixpkgs#jujutsu nixpkgs#python3 --command bash

set -euo pipefail

python update/update.py

if [ "$CI" == "1" ] && [ "$(jj diff)" != "" ]; then
  # there were updates, commit here
  rm result

  jj config set --repo user.name "nttis"
  jj config set --repo user.email "42465069+nttis@users.noreply.github.com"

  jj log -r "all()"

  jj describe -r "mutable()" --author "github-actions <41898282+github-actions[bot]@users.noreply.github.com>"
  jj bookmark set main
  jj git push
else
  echo "No changes to packages!"
fi

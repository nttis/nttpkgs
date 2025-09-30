import sys
import subprocess
import json

stdout = subprocess.run(["nix", "eval", "--json", "--impure", "--file", "update/updates-info.nix"], capture_output=True).stdout
parsed = json.loads(stdout)
clean = True

for packageUpdate in parsed.values():
    subproc = subprocess.run(["nix-update", "--commit", "--build", packageUpdate["pname"]] + packageUpdate["args"])

    if subproc.returncode != 0:
        clean = False;

if clean == False:
    sys.exit(1)

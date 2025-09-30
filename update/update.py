import sys
import subprocess
import json

stdout = subprocess.run(["nix", "eval", "--json", "--impure", "--file", "update/updates-info.nix"], capture_output=True).stdout
parsed = json.loads(stdout)

for packageUpdate in parsed.values():
    subprocess.run(["nix-update", "--commit", "--build", packageUpdate["pname"]] + packageUpdate["args"])

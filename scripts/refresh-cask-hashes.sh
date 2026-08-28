#!/usr/bin/env bash
# Re-pin a cask in modules/aspects/darwin/cask-hashes.json.
#
# Those casks ship without an upstream checksum (Homebrew: `sha256 :no_check`)
# because the vendor serves them from a version-less URL and overwrites the
# file in place. A build failing with a hash mismatch is the expected signal
# that upstream reissued the file -- run this to record the new hash.
#
#   ./scripts/refresh-cask-hashes.sh            # refresh every pinned cask
#   ./scripts/refresh-cask-hashes.sh steam ...  # refresh only these
set -euo pipefail

cd "$(dirname "$0")/.."
json=modules/aspects/darwin/cask-hashes.json
host=${CASK_HOST:-macbook-pro}

mapfile -t casks < <(
  if [ $# -gt 0 ]; then
    printf '%s\n' "$@"
  else
    python3 -c "import json;print('\n'.join(k for k in json.load(open('$json')) if k != '_comment'))"
  fi
)

for cask in "${casks[@]}"; do
  printf '%-22s ' "$cask"

  # Take the URL from brew-api rather than the JSON, so a URL change is picked
  # up here instead of tripping the assertion in _cask-pin.nix.
  url=$(nix eval --raw \
    ".#darwinConfigurations.${host}.pkgs.brewCasks.\"${cask}\".src.urls" \
    --apply 'builtins.head' 2>/dev/null) || { echo "cannot resolve in brew-nix"; continue; }

  hash=$(nix store prefetch-file --json "$url" 2>/dev/null \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["hash"])') \
    || { echo "download failed"; continue; }

  python3 - "$json" "$cask" "$url" "$hash" <<'PY'
import json, sys
path, cask, url, hash_ = sys.argv[1:5]
with open(path) as f:
    data = json.load(f)
old = data.get(cask, {}).get("hash")
data[cask] = {"url": url, "hash": hash_}
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
print("unchanged" if old == hash_ else f"updated  {hash_}")
PY
done

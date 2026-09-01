#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)

for script in "$root"/scripts/*.sh; do
  bash -n "$script"
done

python3 -m json.tool "$root/evals/evals.json" >/dev/null

python3 - "$root" <<'PY'
import pathlib
import re
import sys
import yaml

root = pathlib.Path(sys.argv[1])
for path in (root / "assets/configs").rglob("*.yaml"):
    text = re.sub(r"{%.*?%}", "", path.read_text(encoding="utf-8"))
    text = re.sub(r"{{.*?}}", "placeholder", text)
    doc = yaml.safe_load(text)
    assert doc["version"] == 2 and "workflow" in doc, path
    image = doc.get("default-values", {}).get("anomalygen_image")
    assert image in (None, "nvcr.io/nvidia/paidf-anomalygen:1.1.0"), path
PY

for recipe in "$root"/assets/cookbooks/{pcb,metal_surface,glass}/ag_config.yaml; do
  grep -q '^task_type: texture_ft$' "$recipe"
  grep -Eq '^model_size: (nano|edge)$' "$recipe"
done

if grep -R --exclude=check_anomalygen_1_1.sh \
  -E 'paidf-anomalygen:1\.0|nv-metropolis-dev/metropolis-sdg/paidf-anomalygen|nvcr_io|scripts/anomaly_gen|scripts/utilities|models/(pcb|metal_surface|glass)' \
  "$root/assets" "$root/scripts"; then
  echo "ERROR: retired AnomalyGen contract remains" >&2
  exit 1
fi

echo "AnomalyGen 1.1 skill checks passed"

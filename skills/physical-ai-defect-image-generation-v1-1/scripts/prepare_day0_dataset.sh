#!/usr/bin/env bash
set -euo pipefail

: "${CLEAN_IN:?}"
: "${MASK_IN:?}"
: "${RAW_DATASET:?}"
: "${OUTPUT_DATASET:?}"
: "${ANOMALY_TYPES_JSON:?}"
: "${DEFAULT_SPATIAL_DEPENDENCY:?}"

clean_base=$(find "$CLEAN_IN" -maxdepth 5 -type d -name crop -print -quit)
mask_base=$(find "$MASK_IN" -maxdepth 5 -type d -name crop -print -quit)
test -n "$clean_base"
test -n "$mask_base"
mkdir -p "$OUTPUT_DATASET"

python - "$ANOMALY_TYPES_JSON" "$clean_base" "$mask_base" "$RAW_DATASET" "$OUTPUT_DATASET" <<'PY'
import json
import os
import pathlib
import sys

pairs = json.loads(sys.argv[1])
clean_root, cad_root, raw, out = map(pathlib.Path, sys.argv[2:])

for texture in sorted({texture for texture, _ in pairs}):
    clean_dst = out / texture / "clean_image"
    cad_dst = out / texture / "cad_mask"
    clean_dst.mkdir(parents=True, exist_ok=True)
    cad_dst.mkdir(parents=True, exist_ok=True)

    staged = 0
    for cell in sorted((clean_root / texture).glob("x*_y*")):
        for image in cell.iterdir():
            if image.suffix.lower() not in {".png", ".jpg", ".jpeg"}:
                continue
            name = f"{cell.name}__{image.stem}"
            os.symlink(image, clean_dst / f"{name}{image.suffix.lower()}")
            candidate = cad_root / texture / cell.name / "cad_mask" / f"{image.stem}_cad_mask.png"
            if candidate.is_file():
                os.symlink(candidate, cad_dst / f"{name}.png")
            staged += 1
    if staged == 0:
        raise SystemExit(f"no augmented crops for texture {texture}")

for texture, defect in pairs:
    mask_dst = out / texture / "mask" / defect
    mask_dst.mkdir(parents=True, exist_ok=True)
    candidates = list(raw.glob(f"**/{texture}/mask/{defect}"))
    if not candidates:
        candidates = list(raw.glob(f"**/mask/{defect}"))
    if not candidates:
        raise SystemExit(f"no masks for {texture}+{defect} under {raw}")
    for mask in candidates[0].iterdir():
        if mask.suffix.lower() in {".png", ".jpg", ".jpeg"}:
            target = mask_dst / mask.name
            if not target.exists():
                os.symlink(mask, target)
PY

python /tmp/render_defect_spec.py --output "$OUTPUT_DATASET/defect_spec.jsonl" \
  --pairs "$ANOMALY_TYPES_JSON" --spatial-dependency "$DEFAULT_SPATIAL_DEPENDENCY"

if [[ "$DEFAULT_SPATIAL_DEPENDENCY" == cad ]]; then
  labels=$(find "$MASK_IN" -name semantic_segmentation_labels.json -type f -print -quit)
  test -n "$labels" || { echo "ERROR: cad mode requires semantic_segmentation_labels.json" >&2; exit 1; }
  cp "$labels" "$OUTPUT_DATASET/semantic_segmentation_labels.json"
fi

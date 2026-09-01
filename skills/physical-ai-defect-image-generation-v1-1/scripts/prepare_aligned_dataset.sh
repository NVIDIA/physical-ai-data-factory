#!/usr/bin/env bash
set -euo pipefail

: "${USD2ROI_IN:?}"
: "${RAW_DATASET:?}"
: "${OUTPUT_DATASET:?}"
: "${ANOMALY_TYPES_JSON:?}"
: "${DEFAULT_SPATIAL_DEPENDENCY:?}"

mkdir -p "$OUTPUT_DATASET"

python - "$ANOMALY_TYPES_JSON" "$USD2ROI_IN" "$RAW_DATASET" "$OUTPUT_DATASET" <<'PY'
import json
import os
import pathlib
import sys

pairs = json.loads(sys.argv[1])
render, raw, out = map(pathlib.Path, sys.argv[2:])

for texture, defect in pairs:
    clean_src = render / "crop" / texture / "normal_img"
    clean_dst = out / texture / "clean_image"
    mask_dst = out / texture / "mask" / defect
    clean_dst.mkdir(parents=True, exist_ok=True)
    mask_dst.mkdir(parents=True, exist_ok=True)

    clean = [p for p in clean_src.glob("*") if p.suffix.lower() in {".png", ".jpg", ".jpeg"}]
    if not clean:
        raise SystemExit(f"no aligned clean images under {clean_src}")
    for image in clean:
        target = clean_dst / image.name
        if not target.exists():
            os.symlink(image, target)

    candidates = list(raw.glob(f"**/{texture}/mask/{defect}"))
    if not candidates:
        candidates = list(raw.glob(f"**/mask/{defect}"))
    if not candidates:
        raise SystemExit(f"no masks for {texture}+{defect} under {raw}")
    masks = [p for p in candidates[0].glob("*") if p.suffix.lower() in {".png", ".jpg", ".jpeg"}]
    if not masks:
        raise SystemExit(f"empty mask directory: {candidates[0]}")
    for mask in masks:
        target = mask_dst / mask.name
        if not target.exists():
            os.symlink(mask, target)

    cad_src = render / "crop" / texture / "cad_mask"
    if cad_src.is_dir():
        cad_dst = out / texture / "cad_mask"
        cad_dst.mkdir(parents=True, exist_ok=True)
        for mask in cad_src.glob("*.png"):
            name = mask.name.removesuffix("_cad_mask.png") + ".png"
            target = cad_dst / name
            if not target.exists():
                os.symlink(mask, target)
PY

python /tmp/render_defect_spec.py --output "$OUTPUT_DATASET/defect_spec.jsonl" \
  --pairs "$ANOMALY_TYPES_JSON" --spatial-dependency "$DEFAULT_SPATIAL_DEPENDENCY"

if [[ "$DEFAULT_SPATIAL_DEPENDENCY" == cad ]]; then
  labels=$(find "$USD2ROI_IN" -name semantic_segmentation_labels.json -type f -print -quit)
  test -n "$labels" || { echo "ERROR: cad mode requires semantic_segmentation_labels.json" >&2; exit 1; }
  cp "$labels" "$OUTPUT_DATASET/semantic_segmentation_labels.json"
fi

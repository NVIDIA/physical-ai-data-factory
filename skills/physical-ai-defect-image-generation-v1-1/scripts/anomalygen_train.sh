#!/usr/bin/env bash
set -euo pipefail

: "${PRETRAINED_SRC:?}"
: "${DATASET_DIR:?}"
: "${RECIPE_TEMPLATE:?}"
: "${TRAIN_OUTPUT:?}"
: "${NUM_GPUS:?}"

cd /workspace/paidf-anomalygen

dshm_gb=$(df -B1G /dev/shm | awk 'NR == 2 {print $2}')
(( dshm_gb >= 16 )) || { echo "ERROR: /dev/shm is ${dshm_gb}GiB; need at least 16GiB" >&2; exit 1; }

rm -rf checkpoints
ln -s "$PRETRAINED_SRC" checkpoints
cp "$PRETRAINED_SRC/checkpoint_manifest_converted.sha256" \
  assets/checkpoint_manifest_converted.sha256

test -s "$DATASET_DIR/defect_spec.jsonl"
num_sdg=$(find "$DATASET_DIR" -type f -path '*/mask/*/*' \
  \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' \) | wc -l)
(( num_sdg > 0 )) || { echo "ERROR: no training masks under $DATASET_DIR" >&2; exit 1; }

scripts/preflight_env_ckpt.sh

val_dir=/tmp/anomalygen-validation
rm -rf "$val_dir"
python -m anomalygen.scripts.auto_mask_placement.roi_place_pipeline \
  --num_sdg "$num_sdg" --mode validation \
  --defect_desc "$DATASET_DIR/defect_spec.jsonl" \
  --dataset_dir "$DATASET_DIR" --output_dir "$val_dir" --seed 42
test -s "$val_dir/testcase.jsonl"

recipe=/tmp/exp_texture_ft.yaml
python - "$RECIPE_TEMPLATE" "$recipe" "$DATASET_DIR" "$val_dir/testcase.jsonl" <<'PY'
import sys
import yaml

src, dst, dataset_dir, testcase = sys.argv[1:]
with open(src, encoding="utf-8") as f:
    recipe = yaml.safe_load(f)
recipe["dataset_path"] = dataset_dir
recipe["testcase_jsonl"] = testcase
if recipe["save_iter"] > recipe["max_iter"]:
    raise SystemExit("save_iter must be <= max_iter")
with open(dst, "w", encoding="utf-8") as f:
    yaml.safe_dump(recipe, f, sort_keys=False)
PY

export IMAGINAIRE_OUTPUT_ROOT="$TRAIN_OUTPUT/results"
mkdir -p "$IMAGINAIRE_OUTPUT_ROOT"
torchrun --nproc_per_node="$NUM_GPUS" \
  anomalygen/scripts/texture/train.py \
  --config=cosmos_framework/configs/base/config.py \
  --recipe="$recipe" -- experiment=anomalygen_texture_ft

best=$(find "$TRAIN_OUTPUT" -path '*/checkpoints/best_checkpoint.txt' -type f -print -quit)
test -n "$best" || { echo "ERROR: training produced no best_checkpoint.txt" >&2; exit 1; }
checkpoint=$(dirname "$best")/model/$(cat "$best")
test -f "$checkpoint" || { echo "ERROR: selected checkpoint missing: $checkpoint" >&2; exit 1; }
echo "Training complete: $checkpoint"

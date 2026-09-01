#!/usr/bin/env bash
set -euo pipefail

: "${PRETRAINED_SRC:?}"
: "${DATASET_DIR:?}"
: "${DEFECT_SPEC:?}"
: "${FINETUNE_DIR:?}"
: "${OUTPUT_DIR:?}"
: "${NUM_SDG:?}"
: "${NUM_GPUS:?}"

cd /workspace/paidf-anomalygen

dshm_gb=$(df -B1G /dev/shm | awk 'NR == 2 {print $2}')
(( dshm_gb >= 16 )) || { echo "ERROR: /dev/shm is ${dshm_gb}GiB; need at least 16GiB" >&2; exit 1; }

rm -rf checkpoints
ln -s "$PRETRAINED_SRC" checkpoints
cp "$PRETRAINED_SRC/checkpoint_manifest_converted.sha256" \
  assets/checkpoint_manifest_converted.sha256

scripts/preflight_env_ckpt.sh

if [[ -n "${CHECKPOINT_STEP:-}" ]]; then
  checkpoint_name=$(printf 'iter_%09d.pt' "$CHECKPOINT_STEP")
  checkpoint=$(find "$FINETUNE_DIR" -path "*/checkpoints/model/$checkpoint_name" -type f -print -quit)
  test -n "$checkpoint" || { echo "ERROR: requested checkpoint missing: $checkpoint_name" >&2; exit 1; }
  echo "Using requested checkpoint: $checkpoint_name"
else
  best=$(find "$FINETUNE_DIR" -path '*/checkpoints/best_checkpoint.txt' -type f -print -quit)
  test -n "$best" || { echo "ERROR: finetune output has no best_checkpoint.txt" >&2; exit 1; }
  checkpoint=$(dirname "$best")/model/$(cat "$best")
fi
run_dir=$(dirname "$(dirname "$(dirname "$checkpoint")")")
recipe="$run_dir/exp_texture_ft.yaml"
test -f "$checkpoint"
test -s "$recipe"

gen_dir=/tmp/anomalygen-generation
rm -rf "$gen_dir"
python -m anomalygen.scripts.auto_mask_placement.roi_place_pipeline \
  --num_sdg "$NUM_SDG" --mode inference \
  --defect_desc "$DEFECT_SPEC" --dataset_dir "$DATASET_DIR" \
  --output_dir "$gen_dir" --seed 43
test -s "$gen_dir/testcase.jsonl"

mkdir -p "$OUTPUT_DIR"
torchrun --nproc_per_node="$NUM_GPUS" anomalygen/scripts/texture/generate.py \
  --checkpoint "$checkpoint" --recipe "$recipe" \
  --input_data_path "$gen_dir/testcase.jsonl" --output_dir "$OUTPUT_DIR"

python anomalygen/scripts/texture/pseudo_label.py \
  --gen_root "$OUTPUT_DIR" --output_dir "$OUTPUT_DIR/pseudo_labels" --no_caption

expected=$(wc -l < "$gen_dir/testcase.jsonl")
generated=$(find "$OUTPUT_DIR/reconstructed_image" -maxdepth 1 -type f | wc -l)
blocked=0
if [[ -f "$OUTPUT_DIR/guardrail_blocked.csv" ]]; then
  blocked=$(( $(wc -l < "$OUTPUT_DIR/guardrail_blocked.csv") - 1 ))
fi
(( generated + blocked == expected )) || {
  echo "ERROR: expected $expected results, got $generated generated + $blocked blocked" >&2
  exit 1
}
test -s "$OUTPUT_DIR/pseudo_labels/coco_annotations.json"
echo "Generation complete: $generated images, $blocked guardrail-blocked"

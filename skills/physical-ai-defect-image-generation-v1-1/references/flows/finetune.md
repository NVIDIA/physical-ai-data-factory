# Finetune only

Use `assets/configs/finetune.yaml` to train an AnomalyGen 1.1 texture adapter without running generation. This is also the training stage embedded in every texture-generation workflow; there is no shipped PCBA, metal, or glass adapter.

## Inputs

- `<dig_url_root>/models/pretrained`: Cosmos3 Nano and Edge base checkpoints from `setup/setup_pretrained.yaml`.
- `<dig_url_root>/datasets/<usecase>/raw`: canonical clean images, anomaly images, masks, and `defect_spec.jsonl`.
- `assets/cookbooks/<usecase>/ag_config.yaml`: flat AnomalyGen 1.1 recipe. `model_size` defaults to `nano`.

Run:

```bash
scripts/preflight_credentials.sh
scripts/preflight_pod_template.sh
DIG_URL_ROOT=<root> scripts/preflight_urls.sh finetune <usecase>

STAMP=$(cat /proc/sys/kernel/random/uuid | cut -c1-8)
osmo workflow submit assets/configs/finetune.yaml --pool <pool> \
  --set name=finetune-<usecase>-$STAMP dig_url_root=<root> usecase=<usecase>
```

## Execution contract

The workflow stages the base checkpoint and raw dataset, validates the current AMP dataset layout, patches only `dataset_path` and `testcase_jsonl` in the selected cookbook, then invokes:

```text
anomalygen/scripts/texture/train.py
```

Training must create `best_checkpoint.txt`; a missing pointer or checkpoint fails the task. The complete run directory is uploaded to:

```text
<dig_url_root>/runs/<name>/finetune/
```

Use that run directory with the generation workflow that created it. Do not copy it into `models/<usecase>`: those release-time adapter locations no longer exist.

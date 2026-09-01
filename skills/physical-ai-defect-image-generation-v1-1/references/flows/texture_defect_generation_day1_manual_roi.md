# Day 1 manual ROI

Use `assets/configs/texture_defect_generation_day1_manual_roi.yaml` when the canonical raw dataset already contains clean images, defect images, and masks. It supports `pcb`, `metal_surface`, and `glass`.

Fresh finetuning is the default. To skip it and reuse a completed run adapter,
set `existing_finetune_url` to its `runs/<name>/finetune` output. Generation
follows `best_checkpoint.txt`; set `checkpoint_step` to select an exact saved
iteration.

Run:

```bash
scripts/preflight_credentials.sh
scripts/preflight_pod_template.sh
DIG_URL_ROOT=<root> scripts/preflight_urls.sh 1 <usecase>

STAMP=$(cat /proc/sys/kernel/random/uuid | cut -c1-8)
osmo workflow submit assets/configs/texture_defect_generation_day1_manual_roi.yaml --pool <pool> \
  --set name=day1-<usecase>-$STAMP dig_url_root=<root> usecase=<usecase> num_sdg=30
```

Checkpoint reuse:

```bash
--set existing_finetune_url=<dig_url_root>/runs/<prior-name>/finetune \
  checkpoint_step=<saved-step>
```

The workflow uses `assets/cookbooks/<usecase>/ag_config.yaml`, stages the selected raw dataset, runs `anomalygen/scripts/texture/train.py`, then runs generation, guardrails, and caption-free pseudo-labeling.

```text
[finetune-job] -> anomaly-infer
```

Training output lands at `runs/<name>/finetune`; final labeled output lands at `runs/<name>/anomaly`.

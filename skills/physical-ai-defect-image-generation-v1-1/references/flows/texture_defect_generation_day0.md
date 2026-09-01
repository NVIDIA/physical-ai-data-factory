# Day 0 texture defects

Use `assets/configs/texture_defect_generation_day0.yaml` for cold-start PCB generation from USD assets. The workflow renders component ROIs, augments training examples, trains a fresh AnomalyGen 1.1 adapter, generates defects, applies guardrails, and emits pseudo-labels.

## Inputs

- `<dig_url_root>/models/pretrained`: Cosmos3 base checkpoints.
- `<dig_url_root>/datasets/pcb/raw`: canonical PCB seed data.
- `<dig_url_root>/datasets/pcb/assets`: USD scene and board assets.
- `assets/cookbooks/pcb/<board>/`: USD-to-ROI configuration.
- `assets/cookbooks/pcb/ag_config.yaml`: AnomalyGen training recipe.
- Reachable image-edit endpoint for augmentation.

Run:

```bash
scripts/preflight_credentials.sh
scripts/preflight_pod_template.sh
DIG_URL_ROOT=<root> scripts/preflight_urls.sh 0 pcb

STAMP=$(cat /proc/sys/kernel/random/uuid | cut -c1-8)
osmo workflow submit assets/configs/texture_defect_generation_day0.yaml --pool <pool> \
  --set name=day0-pcb-$STAMP dig_url_root=<root> \
  image_edit_endpoint=<url> \
  anomaly_types_json='[["IC","bridge"],["passive_component","excess_solder"],["passive_component","missing"]]'
```

`board`, `scene_filename`, `render_patches`, `crop_max_emit`, `num_sdg`, and `default_spatial_dependency` are optional overrides. The anomaly pairs must be present in the PCB recipe.

Fresh finetuning is the default. To reuse a completed run adapter, omit the
finetune group with:

```bash
--set existing_finetune_url=<dig_url_root>/runs/<prior-name>/finetune
```

Generation follows that run's `best_checkpoint.txt`. Add
`checkpoint_step=<saved-step>` to select an exact `iter_<step>.pt` instead.
Released `models/<usecase>` checkpoints are not supported.

## Stages and outputs

```text
usd2roi-replicator -> image-edit -> finetune-job -> anomaly-infer
```

Intermediate artifacts land under `runs/<name>/{usd2roi-components,augment,finetune}`. Final labeled output lands under `runs/<name>/anomaly`. The generation task succeeds only when generated plus guardrail-blocked rows account for every testcase row.

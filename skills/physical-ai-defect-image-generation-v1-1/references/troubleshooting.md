# Troubleshooting

Start with the failing OSMO task and its logs:

```bash
osmo workflow query <workflow-id>
osmo workflow logs <workflow-id> --group <group> --task <task>
```

## Preflight failures

- Missing `models/pretrained`: rerun `setup/setup_pretrained.yaml`. It downloads the AnomalyGen 1.1 Cosmos3 Nano and Edge base bundle.
- Missing `datasets/<usecase>/raw`: rerun the matching setup workflow or upload data in the canonical AMP layout.
- Missing PCB assets: rerun `setup/setup_pcb.yaml`.
- Credential probe failure: confirm the Hugging Face token and accept the gated Cosmos3 model licenses.
- `/dev/shm` too small: select a pod template providing at least 16 GiB; 32 GiB is preferred.
- CUDA/driver failure: AnomalyGen 1.1 requires a CUDA 13.2-compatible host driver.

There are intentionally no `models/pcb`, `models/metal_surface`, or `models/glass` artifacts. Every texture workflow trains its own adapter.

## Dataset validation

The current AMP layout is:

```text
<dataset>/<texture>/clean_image/*
<dataset>/<texture>/anomaly_image/<defect>/*
<dataset>/<texture>/mask/<defect>/*
<dataset>/defect_spec.jsonl
```

CAD routing also needs `cad_mask/` and `semantic_segmentation_labels.json`. Material and defect strings must exactly match `anomaly_types` in the selected cookbook. Empty clean-image, anomaly-image, or mask sets fail before training.

## Training failures

- Recipe error: compare `assets/cookbooks/<usecase>/ag_config.yaml` with the flat AnomalyGen 1.1 schema. Old nested `trainer.*`, Predict2, or 2B/14B recipes are incompatible.
- Out of memory: reduce GPU count/batch pressure or raise memory according to `gpu_sizing.md`; each rank loads a Cosmos3 backbone.
- Missing `best_checkpoint.txt`: training did not finish or did not emit a valid best checkpoint. Inspect the training log and run directory; generation must not guess a step.
- Base checkpoint not found: verify both Cosmos3 base directories exist below `models/pretrained` and that the recipe's `model_size` is `nano` or `edge`.

## Generation failures

- Testcase validation error: verify every row's texture, defect, spatial dependency, and referenced image/mask exists.
- CAD-mask error: use `default_spatial_dependency=free` or `text` only if CAD placement is not required; otherwise repair the staged CAD masks.
- Guardrail-blocked output: inspect `guardrail_blocked.csv`. Blocked rows are expected accounting records, not generated images.
- Incomplete output: `generated rows + blocked rows` must equal testcase rows. The workflow fails if the invariant does not hold.
- Missing labels: inspect `pseudo_labels/coco_annotations.json`; OSMO uses `pseudo_label.py --no_caption`, so no VLM caption service is expected.

## Output location

For a run named `<name>`:

```text
<dig_url_root>/runs/<name>/finetune/
<dig_url_root>/runs/<name>/anomaly/
```

Use `references/output_retrieval.md` for download commands and `references/monitoring.md` before querying or restarting a workflow.

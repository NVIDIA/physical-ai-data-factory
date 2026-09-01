# Contents

## Workflows

- `assets/configs/texture_defect_generation_day0.yaml`
- `assets/configs/good_image_generation.yaml`
- `assets/configs/structural_defect_generation.yaml`
- `assets/configs/texture_defect_generation_day1_real_alignment.yaml`
- `assets/configs/texture_defect_generation_day1_manual_roi.yaml`
- `assets/configs/finetune.yaml`
- `assets/configs/setup/setup_{pretrained,pcb,metal,glass}.yaml`

## AnomalyGen 1.1 runners

- `scripts/anomalygen_train.sh`
- `scripts/anomalygen_generate.sh`
- `scripts/prepare_day0_dataset.sh`
- `scripts/prepare_aligned_dataset.sh`
- `scripts/render_defect_spec.py`
- `scripts/check_anomalygen_1_1.sh`

## Preconditions

- `scripts/preflight_credentials.sh`
- `scripts/preflight_pod_template.sh`
- `scripts/preflight_urls.sh`

## Cookbooks

- `assets/cookbooks/{pcb,metal_surface,glass}/ag_config.yaml`
- PCB board and image-edit cookbooks under `assets/cookbooks/pcb/`

Flow walkthroughs live in `references/flows/`; monitoring, retrieval, and
troubleshooting are sibling references.

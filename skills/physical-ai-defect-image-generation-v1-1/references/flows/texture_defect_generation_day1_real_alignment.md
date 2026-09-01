# Day 1 real-photo alignment

Use `assets/configs/texture_defect_generation_day1_real_alignment.yaml` for the PCB Day 1 path that aligns USD renders to a real inspection image before training and generation. Use the manual-ROI flow when alignment is not needed.

## Inputs

- `<dig_url_root>/models/pretrained`
- `<dig_url_root>/datasets/pcb/raw`
- `<dig_url_root>/datasets/pcb/assets`, including the USD scene and `input_real_image/<board>.jpg`
- `assets/cookbooks/pcb/<board>/usd2roi_nvpcb.yaml`
- `assets/cookbooks/pcb/ag_config.yaml`

Run:

```bash
scripts/preflight_credentials.sh
scripts/preflight_pod_template.sh
DIG_URL_ROOT=<root> scripts/preflight_urls.sh 1 pcb real-alignment

STAMP=$(cat /proc/sys/kernel/random/uuid | cut -c1-8)
osmo workflow submit assets/configs/texture_defect_generation_day1_real_alignment.yaml --pool <pool> \
  --set name=day1-aligned-pcb-$STAMP dig_url_root=<root> usecase=pcb \
  board=0603_H100 real_image_filename=input_real_image/0603_H100.jpg
```

The aligned clean crops and masks become the training dataset. A fresh adapter is mandatory; there is no released PCB adapter or pretrained bypass.

```text
usd2roi-render-day1 -> finetune-job -> anomaly-infer
```

Intermediate output lands at `runs/<name>/{usd2roi-day1,finetune}` and final labeled output at `runs/<name>/anomaly`.

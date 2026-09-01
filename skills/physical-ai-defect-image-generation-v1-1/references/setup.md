# Setup

AnomalyGen 1.1 separates shared Cosmos3 base assets from use-case datasets.
It does not distribute fine-tuned PCB, metal, or glass adapters.

## Base assets

```bash
osmo workflow submit assets/configs/setup/setup_pretrained.yaml --pool <pool> \
  --set dig_url_root=<root>
```

Output: `<root>/models/pretrained`.

The task runs `scripts/download_checkpoints.sh` from the pinned AnomalyGen 1.1
development image and stages Cosmos3 Nano and Edge DCP checkpoints,
Wan2.2 VAE, DINOv2, C-RADIO, SAM2, and guardrail/VLM assets. The Hugging Face
account must accept both Cosmos3 model licenses.

## PCB

```bash
osmo workflow submit assets/configs/setup/setup_pcb.yaml --pool <pool> \
  --set dig_url_root=<root>
```

Outputs:

- `<root>/datasets/pcb/raw`
- `<root>/datasets/pcb/assets`

## Metal surface

```bash
osmo workflow submit assets/configs/setup/setup_metal.yaml --pool <pool> \
  --set dig_url_root=<root>
```

Output: `<root>/datasets/metal_surface/raw`.

## Glass

Download the Roboflow Mobile Screen COCO zip, rename it
`mobile_screen.zip`, and upload it to an OSMO URL prefix:

```bash
osmo data upload <zip-prefix>/ /tmp/mobile_screen.zip
osmo workflow submit assets/configs/setup/setup_glass.yaml --pool <pool> \
  --set dig_url_root=<root> uc3_zip_url_root=<zip-prefix>
```

Output: `<root>/datasets/glass/raw`.

Use the prefix form ending in `/`, not a full object key.

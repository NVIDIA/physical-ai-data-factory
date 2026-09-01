# Container images

AnomalyGen workflows use:

```text
nvcr.io/nvidia/paidf-anomalygen:1.1.0
```

Runtime contract:

- CUDA 13.2.1 / Ubuntu 24.04
- Python 3.13.15
- Torch 2.13
- non-root `nvidia` user
- workdir `/workspace/paidf-anomalygen`
- entrypoints under `anomalygen/scripts/`

The workflow YAMLs mount text runner scripts and recipes; model code comes
from the image. Do not substitute a 1.0 image or call
`scripts/anomaly_gen` / `scripts/utilities`.

Other workflow images remain independently pinned in their YAMLs:
`paidf-simulation:1.0.0` and `paidf-augmentation:1.0.0`.

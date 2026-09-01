# Preconditions

## Credentials

Run `scripts/preflight_credentials.sh` once per conversation. It requires the
OSMO `hf-token` credential and, when `HF_TOKEN` is locally available, probes
`nvidia/Cosmos3-Nano` and `nvidia/Cosmos3-Edge`. The public AnomalyGen image
needs no registry credential.

## Pod template

Run `scripts/preflight_pod_template.sh` once per cluster. Training and
generation require at least 16 GiB `/dev/shm`; 32 GiB is preferred. The host
driver must support CUDA 13.2.

## URL artifacts

Run before every submit:

```bash
DIG_URL_ROOT=<root> scripts/preflight_urls.sh <0|1|finetune> <usecase> [real-alignment]
```

| Flow | Required |
|---|---|
| Day 0 texture | `models/pretrained`, `datasets/pcb/raw`, `datasets/pcb/assets` |
| Day 0 good/structural | `datasets/pcb/assets` |
| Day 1 manual | `models/pretrained`, `datasets/<usecase>/raw` |
| Day 1 real alignment | manual requirements plus `datasets/pcb/assets` |
| Finetune | `models/pretrained`, `datasets/<usecase>/raw` |

There are no `models/<usecase>` artifacts.

## Run names

Generate a fresh name before every submit:

```bash
STAMP=$(cat /proc/sys/kernel/random/uuid | cut -c1-8)
```

Pass `--set name=<flow>-$STAMP`.

## Stable defaults

- PCBA Day 1: real alignment
- Board: `0603_H100`
- Cosmos3 model size: `nano`, from the use-case recipe
- Image-edit model: `nvidia/Qwen-Image-Edit-NVPCB-OVSL2SL`
- Real-alignment spatial dependency: `cad`

Training is mandatory for every AnomalyGen generation workflow.

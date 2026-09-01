# GPU and memory sizing

AnomalyGen 1.1 uses CUDA 13.2, Torch 2.13, and Cosmos3 Nano/Edge. The old
Predict2 measurements do not apply.

The shipped OSMO defaults are the conservative starting envelope:

| Task | GPU | CPU | Host memory | Storage |
|---|---:|---:|---:|---:|
| Finetune | 1 | 16 | 96 GiB | 300 GiB |
| Generate + pseudo-label | 1 | 8 | 96 GiB | 250 GiB |

Do not publish a multi-GPU sizing table until it has been measured on the
target cluster. Every rank loads model state, so GPU count and host memory
must be validated together.

All GPU tasks require at least 16 GiB `/dev/shm`.

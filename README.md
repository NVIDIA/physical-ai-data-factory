<!--
SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
SPDX-License-Identifier: CC-BY-4.0 AND Apache-2.0
-->

# Physical AI Data Factory

Physical AI Data Factory (PAIDF) provides repeatable, scalable, agent-driven
workflows for curating, enriching, labeling, augmenting, and generating
physical AI data across distributed compute.

This repository is an entry point for currently published PAIDF workflows. It
contains **agent skills** for running workflows on
[NVIDIA OSMO](https://developer.nvidia.com/osmo), plus links to the Airflow-based
DAGs maintained in [NVIDIA/paidf-orchestration](https://github.com/NVIDIA/paidf-orchestration).

## PAIDF ecosystem

PAIDF workflows compose reusable core modules into end-to-end data operations.

### PAIDF workflows

| Workflow | What it does | Use cases | Execution path |
|----------|--------------|-----------|----------------|
| **[Defect Image Generation (DIG)](skills/physical-ai-defect-image-generation/SKILL.md)** | Synthesizes labeled defect and clean images by chaining USD rendering, appearance transfer, and anomaly generation, with optional fine-tuning. | Automated optical inspection for PCBA, metal surfaces, and glass | OSMO agent skill |
| **[Video Data Augmentation (VDA)](skills/physical-ai-video-data-augmentation/SKILL.md)** | Augments video and generates pseudo-labels using Cosmos-based generation and auto-labeling stages. | Video analytics and event-video training data | OSMO agent skill |
| **[Image Attribute Augmentation (IAA)](https://github.com/NVIDIA/paidf-orchestration/blob/main/docs/image-attribute-augmentation/getting-started.md)** | Generates controlled variations of clothing, color, footwear, and other visible attributes from person-crop datasets. | Person re-identification and attribute search | Airflow DAG on Kubernetes |
| **[Event Video Generation (EVG)](https://github.com/NVIDIA/paidf-orchestration/blob/main/docs/event-video-generation/getting-started.md)** | Turns seed images into annotated videos with controlled events such as fire, falling, shoplifting, and fighting. | Safety and surveillance event detection | Airflow DAG on Kubernetes |

### PAIDF core modules

| Core module | What it provides | Repository |
|-------------|------------------|------------|
| **Orchestration** | Airflow-based workflow orchestration on Kubernetes for deploying services and scaling PAIDF data operations. | [NVIDIA/paidf-orchestration](https://github.com/NVIDIA/paidf-orchestration) |
| **Auto Labeling** | Config-driven enrichment and labeling across super-resolution, detection and tracking, scene understanding, and task-question generation. | [NVIDIA/paidf-auto-labeling](https://github.com/NVIDIA/paidf-auto-labeling) |
| **Augmentation** | Generative-AI data augmentation for video, image, and text, using backends such as Cosmos Transfer, Cosmos Predict, and image-edit models. | [NVIDIA/paidf-augmentation](https://github.com/NVIDIA/paidf-augmentation) |
| **AnomalyGen** | Few-shot, diffusion-based generation of photorealistic, mask-aligned anomaly images for industrial visual inspection. | [NVIDIA/paidf-anomalygen](https://github.com/NVIDIA/paidf-anomalygen) |
| **Simulation** | Isaac Sim and Omniverse Replicator pipelines for generating photorealistic, fully labeled inspection imagery. | [NVIDIA/paidf-simulation](https://github.com/NVIDIA/paidf-simulation) |
| **Curation and Retrieval** | Cosmos Curator, NVIDIA TAO Data services pipelines for curating and retrieving image and video datasets. | [NVIDIA/paidf-curation-and-retrieval](https://github.com/NVIDIA/paidf-curation-and-retrieval) |

## Repository layout

```text
skills/        Agent skills (the product). Canonical source.
docs/          Per-workflow environment guides and setup walkthroughs.
.claude/ .codex/ .agents/   Agent-tool entry points (symlinked to skills/).
```

The `.claude/skills`, `.codex/skills`, and `.agents/skills` directories are
symlinks to `skills/`, so the same canonical skills are discovered automatically
by each agent runtime.

## Getting started

Choose the orchestration path that fits your environment:

- **[OSMO](https://developer.nvidia.com/osmo)** - provision a GPU runtime
  environment, pull sample assets, and open [OpenClaw](https://openclaw.ai) or
  your preferred coding agent to drive the workflow.
- **Airflow on Kubernetes** - follow the
  [PAIDF Orchestration getting-started guide](https://github.com/NVIDIA/paidf-orchestration/blob/main/docs/getting-started.md),
  then launch either DAG (IAA or EVG) from the Airflow UI.

OSMO workflow guides:

- **Defect Image Generation** - see
  [docs/workflows/physical-ai-defect-image-generation/launchable.md](docs/workflows/physical-ai-defect-image-generation/launchable.md)
- **Video Data Augmentation** - see
  [docs/workflows/physical-ai-video-data-augmentation/launchable.md](docs/workflows/physical-ai-video-data-augmentation/launchable.md)

To use a skill directly with your own agent, point the agent at the relevant
`skills/<name>/SKILL.md` and follow its prompts. The skill handles flow
selection, preconditions, data handoffs, and OSMO submit/monitor commands.

### Prerequisites

The OSMO workflows pull gated assets, so you'll generally need:

- **NGC credentials** to pull container images from `nvcr.io`.
- **A Hugging Face read token** for gated Cosmos, AnomalyGen, and Qwen-Image-Edit
  models and datasets (accept each model's license first).
- **OSMO CLI access** with a logged-in profile and an available GPU pool.

The exact secrets, model/dataset links, and resource sizing are listed in each
workflow's environment guide.

## Contributing

This project is currently **not accepting external contributions**. The
repository is published as-is for reference and reproducibility; issues and
pull requests from community members will not be reviewed or merged at this
time. If contributions are reopened, all commits must be signed off per the
Developer Certificate of Origin - see [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

To report a vulnerability, contact the NVIDIA PSIRT rather than opening a public
issue. See [SECURITY.md](SECURITY.md).

## License

Code is licensed under **Apache-2.0** and documentation/skill content under
**CC-BY-4.0** (`CC-BY-4.0 AND Apache-2.0`). See [LICENSE](LICENSE).

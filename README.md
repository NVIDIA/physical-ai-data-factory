<!--
SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
SPDX-License-Identifier: CC-BY-4.0 AND Apache-2.0
-->

# Physical AI Data Factory

Agent skills and workflow documentation for generating **labeled synthetic
training data for physical-AI inspection and perception models** — without
waiting for every real defect or rare event to appear in production.

This repository does not ship application code. It ships **agent skills**:
prompt-driven orchestrators that an AI agent (Claude Code, Codex, OpenClaw/Claw,
or any compatible agent) follows to run end-to-end synthetic data generation
pipelines on [NVIDIA OSMO](https://developer.nvidia.com/osmo) from a
provisioned GPU runtime environment.

## What's inside

| Skill | What it does | Use cases |
|-------|--------------|-----------|
| **[Defect Image Generation (DIG)](skills/physical-ai-defect-image-generation/SKILL.md)** | Synthesizes labeled defect and clean images for Automated Optical Inspection (AOI) by chaining USD rendering (USD-to-ROI), Qwen Image-Edit appearance transfer, and Cosmos AnomalyGen — with optional finetuning. Day 0 (cold start from CAD/USD) and Day 1 (inference + labeling on real photos) paths. | PCBA, metal surface, glass |
| **[Video Data Augmentation (VDA)](skills/physical-ai-video-data-augmentation/SKILL.md)** | Runs video augmentation and auto-labeling (pseudo-labeling) on OSMO using Cosmos, covering flow selection, preflight, submit-time interpolation, monitoring, and output retrieval. | Video analytics / event video  |

Each skill is self-contained under `skills/<name>/`, with its canonical OSMO
workflow YAMLs in `assets/configs/`, use-case cookbooks in `assets/cookbooks/`,
and long-form guidance in `references/`.

## Repository layout

```text
skills/        Agent skills (the product). Canonical source.
docs/          Per-workflow environment guides and setup walkthroughs.
.claude/ .codex/ .agents/   Agent-tool entry points (symlinked to skills/).
```

The `.claude/skills`, `.codex/skills`, and `.agents/skills` directories are
symlinks to `skills/`, so the same canonical skill is discovered automatically
by each agent runtime.

## Getting started

The fastest path is to provision a GPU runtime environment, pull sample assets,
and open an agent (Claw or your preferred coding agent) that drives the workflow
for you:

- **Defect Image Generation** — see
  [docs/workflows/physical-ai-defect-image-generation/launchable.md](docs/workflows/physical-ai-defect-image-generation/launchable.md)
- **Video Data Augmentation** — see
  [docs/workflows/physical-ai-video-data-augmentation/launchable.md](docs/workflows/physical-ai-video-data-augmentation/launchable.md)

To use a skill directly with your own agent, point the agent at the relevant
`skills/<name>/SKILL.md` and follow its prompts. The skill handles flow
selection, preconditions, data handoffs, and OSMO submit/monitor commands.

### Prerequisites

Workflows run on OSMO and pull gated assets, so you'll generally need:

- **NGC credentials** to pull container images from `nvcr.io`.
- **A Hugging Face read token** for gated Cosmos / AnomalyGen / Qwen-Image-Edit
  models and datasets (accept each model's license first).
- **OSMO CLI access** with a logged-in profile and an available GPU pool.

The exact secrets, model/dataset links, and resource sizing are listed in each
workflow's environment guide.

## Contributing

This project is currently **not accepting external contributions**. The
repository is published as-is for reference and reproducibility; issues and
pull requests from community members will not be reviewed or merged at this
time. If contributions reopen, all commits must be signed off per the Developer
Certificate of Origin — see [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

To report a vulnerability, contact the NVIDIA PSIRT rather than opening a public
issue. See [SECURITY.md](SECURITY.md).

## License

Code is licensed under **Apache-2.0** and documentation/skill content under
**CC-BY-4.0** (`CC-BY-4.0 AND Apache-2.0`). See [LICENSE](LICENSE).

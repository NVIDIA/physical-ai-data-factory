## Description: <br>
Orchestrates NVIDIA Cosmos3-based AnomalyGen 1.1 defect image generation on OSMO, chaining Day 0 USD-to-ROI, Qwen image-edit augmentation, LoRA finetuning, and generation, plus Day 1 checkpoint reuse, inference, and labeling for PCBA, metal surfaces, and glass. <br>

This skill is ready for commercial/non-commercial use. <br>

## Owner
NVIDIA <br>

### License/Terms of Use: <br>
CC-BY-4.0 AND Apache-2.0 <br>
## Use Case: <br>
Developers and engineers use this skill to generate labeled synthetic defect and clean images for Automated Optical Inspection (AOI) datasets by orchestrating end-to-end data generation pipelines on NVIDIA OSMO. <br>

### Deployment Geography for Use: <br>
Global <br>

## Requirements / Dependencies: <br>
**Requires API Key or External Credential:** [Yes] <br>
**Credential Type(s):** [API key] <br>

Do not include secrets in prompts/logs/output; use least-privilege credentials; rotate keys as appropriate. <br>

## Known Risks and Mitigations: <br>
Risk: Review before execution as proposals could introduce incorrect or misleading guidance into skills. <br>
Mitigation: Review and scan skill before deployment. <br>

## Reference(s): <br>
- [NVIDIA OSMO](https://developer.nvidia.com/osmo) <br>
- [Setup Guide](references/setup.md) <br>
- [Preconditions](references/preconditions.md) <br>
- [Knob Mapping](references/knob_mapping.md) <br>
- [GPU Sizing](references/gpu_sizing.md) <br>
- [Monitoring](references/monitoring.md) <br>
- [Output Rendering](references/output_rendering.md) <br>
- [Output Retrieval](references/output_retrieval.md) <br>
- [Troubleshooting](references/troubleshooting.md) <br>
- [Container Images](references/container-images.md) <br>
- [NIM Deployment](references/nim/README.md) <br>
- [Contents](references/contents.md) <br>


## Skill Output: <br>
**Output Type(s):** [Shell commands, Configuration instructions] <br>
**Output Format:** [Markdown with inline bash code blocks] <br>
**Output Parameters:** [1D] <br>
**Other Properties Related to Output:** [None] <br>

## Evaluation Agents Used: <br>
- Claude Code (`aws/anthropic/bedrock-claude-opus-4-8`) <br>
- Codex (`openai/openai/gpt-5.5`) <br>



## Evaluation Tasks: <br>
Evaluated against 6 evaluation tasks (6 positive) in k8s-sandbox environment with 1 attempt per task. <br>

## Evaluation Metrics Used: <br>
Reported benchmark dimensions: <br>
- Security: Checks for unsafe operations, secret leakage, and unauthorized access. <br>
- Correctness: Checks final-answer correctness against the reference answer. <br>
- Discoverability: Checks whether the expected skill was found and executed when needed. <br>
- Effectiveness: Checks whether the skill helped complete the user's goal and followed expected workflow behavior. <br>
- Efficiency: Checks routing quality, workspace-aware skill reads, and productive tool use. <br>

Underlying evaluation signals used in this run: <br>
- `security`: Unsafe operations, secret leakage, and unauthorized access. <br>
- `accuracy`: Final-answer correctness against the reference answer. <br>
- `skill_execution`: Whether the expected skill was found and executed. <br>
- `goal_accuracy`: Whether the user's goal was achieved. <br>
- `behavior_check`: Whether the expected workflow behavior was followed. <br>
- `skill_efficiency`: Routing quality, workspace-aware skill reads, and productive tool use. <br>



## Evaluation Results: <br>
| Measure | Claude Code (Baseline → Skill Uplift) | Codex (Baseline → Skill Uplift) |
|---|---:|---:|
| Overall | 37% → 94% (+58 points) | 49% → 93% (+44 points) |
| Security | 83% → 100% (+17 points) | 75% → 100% (+25 points) |
| Correctness | 7% → 93% (+87 points) | 63% → 93% (+30 points) |
| Discoverability | 47% → 100% (+53 points) | 43% → 84% (+42 points) |
| Effectiveness | 10% → 82% (+72 points) | 33% → 88% (+55 points) |
| Efficiency | 37% → 97% (+60 points) | 31% → 100% (+69 points) |

## Skill Version(s): <br>
1.1.0 (source: frontmatter) <br>

## Ethical Considerations: <br>
NVIDIA believes Trustworthy AI is a shared responsibility and we have established policies and practices to enable development for a wide array of AI applications. When downloaded or used in accordance with our terms of service, developers should work with their internal team to ensure this skill meets requirements for the relevant industry and use case and addresses unforeseen product misuse. <br>

(For Release on NVIDIA Platforms Only) <br>
Please report quality, risk, security vulnerabilities or NVIDIA AI Concerns [here](https://app.intigriti.com/programs/nvidia/nvidiavdp/detail). <br>

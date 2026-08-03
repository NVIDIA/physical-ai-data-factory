## Description: <br>
Use when running image attribute augmentation and auto-labeling workflows on OSMO: flow selection, preflight, submit-time interpolation, monitoring, and output retrieval. <br>

This skill is ready for commercial/non-commercial use. <br>

## Owner
NVIDIA <br>

### License/Terms of Use: <br>
CC-BY-4.0 AND Apache-2.0 <br>
## Use Case: <br>
Developers and engineers use this skill to run end-to-end image attribute augmentation and auto-labeling pipelines on NVIDIA OSMO, generating controlled appearance variations and subject-attribute captions for physical-AI perception model training. The subject is a person today, but the pipeline generalizes to other subjects such as robots, forklifts, or vehicles in simulation. <br>

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
- [Augmentation Flow](references/flows/augmentation.md) <br>
- [Auto-Labeling Flow](references/flows/auto_labeling.md) <br>
- [End-to-End Flow](references/flows/e2e.md) <br>
- [Setup Guide](references/setup.md) <br>
- [Troubleshooting](references/troubleshooting.md) <br>
- [NIM Configuration](references/nim/README.md) <br>
- [Container Images](references/container-images.md) <br>


## Skill Output: <br>
**Output Type(s):** [Shell commands, Configuration instructions, Files] <br>
**Output Format:** [Markdown with inline bash code blocks] <br>
**Output Parameters:** [1D] <br>
**Other Properties Related to Output:** [None] <br>

## Evaluation Agents Used: <br>
- Claude Code (`aws/anthropic/bedrock-claude-opus-4-8`) <br>
- Codex (`openai/openai/gpt-5.5`) <br>



## Evaluation Tasks: <br>
Evaluated against 10 tasks (7 positive, 3 negative) in isolated k8s-sandbox pods. <br>

## Evaluation Metrics Used: <br>
Reported benchmark dimensions: <br>
- Security: Whether the skill avoids unsafe operations, secret leakage, and unauthorized access. <br>
- Correctness: Whether the final answer is correct against the reference answer. <br>
- Discoverability: Whether the expected skill was found and executed when needed. <br>
- Effectiveness: Whether the skill helps the agent complete the user's goal and follow expected workflow behavior. <br>
- Efficiency: Whether the skill avoids wasted tool or skill usage through routing quality and productive tool use. <br>

Underlying evaluation signals used in this run: <br>
- `security`: Checks for unsafe operations, secret leakage, and unauthorized access. <br>
- `skill_execution`: Verifies the expected skill was found and executed. <br>
- `skill_efficiency`: Evaluates routing quality, workspace-aware skill reads, and productive tool use. <br>
- `accuracy`: Measures final-answer correctness against the reference answer. <br>
- `goal_accuracy`: Assesses whether the user's goal was achieved. <br>
- `behavior_check`: Verifies the expected workflow behavior was followed. <br>



## Evaluation Results: <br>
| Measure | Claude Code (Baseline → Skill Uplift) | Codex (Baseline → Skill Uplift) |
|---|---:|---:|
| Overall | 53% → 86% (+33 points) | 52% → 83% (+31 points) |
| Security | 90% → 95% (+5 points) | 65% → 95% (+30 points) |
| Correctness | 30% → 90% (+60 points) | 54% → 74% (+20 points) |
| Discoverability | 57% → 88% (+30 points) | 52% → 82% (+30 points) |
| Effectiveness | 41% → 74% (+33 points) | 41% → 81% (+41 points) |
| Efficiency | 48% → 85% (+37 points) | 48% → 84% (+35 points) |

## Skill Version(s): <br>
1.0.0 (source: frontmatter) <br>

## Ethical Considerations: <br>
NVIDIA believes Trustworthy AI is a shared responsibility and we have established policies and practices to enable development for a wide array of AI applications. When downloaded or used in accordance with our terms of service, developers should work with their internal team to ensure this skill meets requirements for the relevant industry and use case and addresses unforeseen product misuse. <br>

(For Release on NVIDIA Platforms Only) <br>
Please report quality, risk, security vulnerabilities or NVIDIA AI Concerns [here](https://app.intigriti.com/programs/nvidia/nvidiavdp/detail). <br>

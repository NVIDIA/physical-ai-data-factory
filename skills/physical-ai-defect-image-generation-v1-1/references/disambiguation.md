# Disambiguation

Ask only when the request leaves a load-bearing choice unresolved.

| Request | Clarify |
|---|---|
| “Generate defects” | Day 0 texture, structural, or Day 1? |
| “Day 1 PCBA” | Use real alignment silently unless manual ROI was requested. |
| “Generate N images” | For AnomalyGen, map N to `num_sdg`; for Day 0 renderer output, map final crops to `crop_max_emit`. |
| “Run metal/glass” | Use Day 1 manual ROI. |
| First run | Confirm `dig_url_root`, pool, and Day 0 image-edit endpoint. |

Do not ask about pretrained checkpoints or passthrough; neither exists.

`dig_url_root` has no silent first-run default because setup writes a large
base-model bundle there.

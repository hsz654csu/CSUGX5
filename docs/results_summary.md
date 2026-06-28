# Results Summary

Run all scenarios with:

```matlab
addpath('scripts')
run_all
```

The generated results are saved under `results/`.

## Scenarios

| Scenario | Mode | Target |
|---|---:|---|
| Hover | 1 | Hold near `(0, 0, 3) m` |
| Level flight | 2 | Move to about `x = 6 m`, hold `z = 3 m` |
| Climb | 3 | Move from hover altitude to about `z = 5 m` |
| Lateral shift | 4 | Move to about `y = 3 m`, hold `z = 3 m` |

## Typical Metrics

| Scenario | Final position / m | Final position error / m | Main steady RMS error |
|---|---|---|---|
| Hover | `[0.0000, 0.0000, 3.0054]` | `[0.0000, 0.0000, -0.0054]` | z: `0.0055 m` |
| Level flight | `[5.9501, 0.0000, 3.0054]` | `[0.0499, 0.0000, -0.0054]` | x: `0.0684 m` |
| Climb | `[0.0000, 0.0000, 5.0061]` | `[0.0000, 0.0000, -0.0061]` | z: `0.0077 m` |
| Lateral shift | `[0.0000, 2.9827, 3.0054]` | `[0.0000, 0.0173, -0.0054]` | y: `0.0345 m` |

## Documentation Figures

Selected example figures are included in `docs/figures/`. Full scenario plots are regenerated under `results/` whenever `run_all` is executed.

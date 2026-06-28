# Release Checklist

Before publishing this repository:

- [ ] Open MATLAB in the repository root.
- [ ] Run `addpath('scripts')`.
- [ ] Run `run_all`.
- [ ] Confirm that hover, level-flight, climb, and lateral-shift scenarios complete.
- [ ] Confirm that `results/` is ignored by Git unless you intentionally want to publish generated result files.
- [ ] Confirm that no private report, handout, template, or personal document is included.
- [ ] Update README if scenario targets, parameters, or script names change.

## Files Intended for GitHub

- `README.md`
- `LICENSE`
- `.gitignore`
- `CONTRIBUTING.md`
- `model/uav_6dof_course.slx`
- `scripts/*.m`
- `docs/*.md`
- selected `docs/figures/*.png`
- `examples/run_project.m`

## Files Not Intended for GitHub

- `results/`
- `slprj/`
- Word/PDF reports
- course assignment sheets
- private templates
- autosave/cache files

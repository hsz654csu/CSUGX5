# Contributing

Contributions are welcome. Please keep the project focused on MATLAB/Simulink UAV 6-DOF simulation.

## Recommended Workflow

1. Create a branch for your change.
2. Run the full verification set:

   ```matlab
   addpath('scripts')
   run_all
   ```

3. Confirm that all four scenarios complete successfully.
4. If controller or dynamics behavior changes, update `docs/results_summary.md`.

## Coding Notes

- Keep scripts compatible with MATLAB R2024a unless there is a clear reason to require a newer version.
- Keep generated results under `results/`; this directory is ignored by Git.
- Do not commit `slprj/`, autosave files, or local MATLAB cache files.
- Do not commit private course reports, handouts, or personal documents.

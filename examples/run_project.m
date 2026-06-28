%RUN_PROJECT Minimal example entry point for the UAV 6-DOF Simulink project.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
cd(projectRoot);
addpath(fullfile(projectRoot, 'scripts'));

summary = run_all();
disp(summary);

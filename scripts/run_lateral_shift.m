function metrics = run_lateral_shift()
%RUN_LATERAL_SHIFT Run the lateral-shift verification case.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
modelName = 'uav_6dof_course';
modelPath = fullfile(projectRoot, 'model', [modelName '.slx']);
if ~exist(modelPath, 'file')
    create_course_model();
end

load_system(modelPath);
set_param(modelName, 'StopTime', '20');
set_param([modelName '/ScenarioMode'], 'Value', '4');
simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');
close_system(modelName, 0);

metrics = plot_sim_results(simOut, 'lateral_shift', fullfile(projectRoot, 'results', 'lateral_shift'));
end

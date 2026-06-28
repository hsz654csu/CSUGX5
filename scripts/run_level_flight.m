function metrics = run_level_flight()
%RUN_LEVEL_FLIGHT Run the level-flight/straight-flight verification case.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
modelName = 'uav_6dof_course';
modelPath = fullfile(projectRoot, 'model', [modelName '.slx']);
if ~exist(modelPath, 'file')
    create_course_model();
end

load_system(modelPath);
set_param(modelName, 'StopTime', '20');
set_param([modelName '/ScenarioMode'], 'Value', '2');
simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');
close_system(modelName, 0);

metrics = plot_sim_results(simOut, 'level_flight', fullfile(projectRoot, 'results', 'level_flight'));
end

function metrics = run_climb()
%RUN_CLIMB Run the climb/altitude-change verification case.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
modelName = 'uav_6dof_course';
modelPath = fullfile(projectRoot, 'model', [modelName '.slx']);
if ~exist(modelPath, 'file')
    create_course_model();
end

load_system(modelPath);
set_param(modelName, 'StopTime', '20');
set_param([modelName '/ScenarioMode'], 'Value', '3');
simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');
close_system(modelName, 0);

metrics = plot_sim_results(simOut, 'climb', fullfile(projectRoot, 'results', 'climb'));
end

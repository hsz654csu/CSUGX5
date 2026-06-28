function summary = run_all()
%RUN_ALL Rebuild the course model and run all required verification cases.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(projectRoot, 'scripts'));

create_course_model();
P = init_uav_params(); %#ok<NASGU>
hover = run_hover();
level_flight = run_level_flight();
climb = run_climb();
lateral_shift = run_lateral_shift();
export_interface_summary();

summary = struct('hover', hover, 'level_flight', level_flight, 'climb', climb, 'lateral_shift', lateral_shift);
save(fullfile(projectRoot, 'results', 'summary_metrics.mat'), 'summary');

fprintf('\nAll simulations completed.\n');
fprintf('Hover final position:       [%.3f %.3f %.3f] m\n', hover.final_position);
fprintf('Level-flight final position:[%.3f %.3f %.3f] m\n', level_flight.final_position);
fprintf('Climb final position:       [%.3f %.3f %.3f] m\n', climb.final_position);
fprintf('Lateral final position:     [%.3f %.3f %.3f] m\n', lateral_shift.final_position);
fprintf('Results folder: %s\n', fullfile(projectRoot, 'results'));
end

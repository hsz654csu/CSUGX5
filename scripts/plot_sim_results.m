function metrics = plot_sim_results(simOut, scenarioName, outputDir)
%PLOT_SIM_RESULTS Save standard figures and numeric metrics.

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

[t, state] = unpack_ts(simOut.get('sim_state'));
[~, refPos] = unpack_ts(simOut.get('sim_ref_pos'));
[~, attRef] = unpack_ts(simOut.get('sim_att_ref'));
[~, control] = unpack_ts(simOut.get('sim_control'));
[~, rotorSpeed] = unpack_ts(simOut.get('sim_rotor_speed'));

pos = state(:, 1:3);
vel = state(:, 4:6);
euler = state(:, 7:9);
rates = state(:, 10:12);

metrics = struct();
metrics.scenario = scenarioName;
metrics.duration = t(end) - t(1);
metrics.final_position = pos(end, :);
metrics.final_velocity = vel(end, :);
metrics.final_euler_deg = rad2deg(euler(end, :));
metrics.final_position_error = refPos(end, :) - pos(end, :);
metrics.max_abs_position_error = max(abs(refPos - pos), [], 1);
metrics.rms_position_error = sqrt(mean((refPos - pos).^2, 1));
steadyIdx = t >= max(t(end) - 5, t(1));
metrics.steady_rms_position_error = sqrt(mean((refPos(steadyIdx, :) - pos(steadyIdx, :)).^2, 1));
metrics.steady_max_abs_position_error = max(abs(refPos(steadyIdx, :) - pos(steadyIdx, :)), [], 1);
metrics.x_overshoot = max(pos(:, 1) - refPos(:, 1));
metrics.z_overshoot = max(pos(:, 3) - refPos(:, 3));
metrics.max_abs_euler_deg = max(abs(rad2deg(euler)), [], 1);
metrics.max_rotor_speed = max(rotorSpeed, [], 1);
metrics.min_rotor_speed = min(rotorSpeed, [], 1);

save(fullfile(outputDir, [scenarioName '_result.mat']), ...
    't', 'state', 'refPos', 'attRef', 'control', 'rotorSpeed', 'metrics');

fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 80 1100 760]);
tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
nexttile;
plot(t, refPos(:,1), 'k--', t, pos(:,1), 'r', t, refPos(:,2), 'k:', t, pos(:,2), 'g', t, refPos(:,3), 'k-.', t, pos(:,3), 'b', 'LineWidth', 1.2);
grid on; xlabel('Time / s'); ylabel('Position / m');
legend('x ref','x','y ref','y','z ref','z', 'Location', 'best');
title([scenarioName ' position tracking']);

nexttile;
plot(t, vel(:,1), 'r', t, vel(:,2), 'g', t, vel(:,3), 'b', 'LineWidth', 1.2);
grid on; xlabel('Time / s'); ylabel('Velocity / (m/s)');
legend('vx','vy','vz', 'Location', 'best');

nexttile;
plot(t, rad2deg(euler(:,1)), 'r', t, rad2deg(euler(:,2)), 'g', t, rad2deg(euler(:,3)), 'b', ...
     t, rad2deg(attRef(:,1)), 'r--', t, rad2deg(attRef(:,2)), 'g--', t, rad2deg(attRef(:,3)), 'b--', 'LineWidth', 1.2);
grid on; xlabel('Time / s'); ylabel('Euler angle / deg');
legend('\phi','\theta','\psi','\phi ref','\theta ref','\psi ref', 'Location', 'best');
exportgraphics(fig, fullfile(outputDir, [scenarioName '_state_response.png']), 'Resolution', 180);
close(fig);

fig = figure('Visible', 'off', 'Color', 'w', 'Position', [120 120 1100 620]);
tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
nexttile;
plot(t, control, 'LineWidth', 1.2);
grid on; xlabel('Time / s'); ylabel('Control');
legend('U1','\tau_\phi','\tau_\theta','\tau_\psi', 'Location', 'best');
title([scenarioName ' control inputs']);

nexttile;
plot(t, rotorSpeed, 'LineWidth', 1.2);
grid on; xlabel('Time / s'); ylabel('Rotor speed / (rad/s)');
legend('w1','w2','w3','w4', 'Location', 'best');
exportgraphics(fig, fullfile(outputDir, [scenarioName '_control_rotor.png']), 'Resolution', 180);
close(fig);

fig = figure('Visible', 'off', 'Color', 'w', 'Position', [160 100 900 700]);
plot3(pos(:,1), pos(:,2), pos(:,3), 'b', 'LineWidth', 1.6); hold on;
plot3(refPos(:,1), refPos(:,2), refPos(:,3), 'k--', 'LineWidth', 1.2);
grid on; axis equal;
xlabel('x / m'); ylabel('y / m'); zlabel('z / m');
legend('actual path', 'reference path', 'Location', 'best');
title([scenarioName ' 3D trajectory']);
exportgraphics(fig, fullfile(outputDir, [scenarioName '_trajectory_3d.png']), 'Resolution', 180);
close(fig);

write_metrics(metrics, fullfile(outputDir, [scenarioName '_metrics.txt']));
end

function [time, data] = unpack_ts(ts)
time = ts.Time(:);
data = ts.Data;
if ndims(data) == 3
    data = squeeze(data);
    if size(data, 1) ~= numel(time)
        data = data.';
    end
end
if isvector(data)
    data = data(:);
end
end

function write_metrics(metrics, filename)
fid = fopen(filename, 'w');
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, 'Scenario: %s\n', metrics.scenario);
fprintf(fid, 'Duration: %.3f s\n', metrics.duration);
fprintf(fid, 'Final position [x y z] m: %.4f %.4f %.4f\n', metrics.final_position);
fprintf(fid, 'Final velocity [vx vy vz] m/s: %.4f %.4f %.4f\n', metrics.final_velocity);
fprintf(fid, 'Final Euler [phi theta psi] deg: %.4f %.4f %.4f\n', metrics.final_euler_deg);
fprintf(fid, 'Final position error [x y z] m: %.4f %.4f %.4f\n', metrics.final_position_error);
fprintf(fid, 'Max abs position error [x y z] m: %.4f %.4f %.4f\n', metrics.max_abs_position_error);
fprintf(fid, 'RMS position error [x y z] m: %.4f %.4f %.4f\n', metrics.rms_position_error);
fprintf(fid, 'Steady RMS position error, last 5s [x y z] m: %.4f %.4f %.4f\n', metrics.steady_rms_position_error);
fprintf(fid, 'Steady max abs position error, last 5s [x y z] m: %.4f %.4f %.4f\n', metrics.steady_max_abs_position_error);
fprintf(fid, 'Positive overshoot [x z] m: %.4f %.4f\n', metrics.x_overshoot, metrics.z_overshoot);
fprintf(fid, 'Max abs Euler [phi theta psi] deg: %.4f %.4f %.4f\n', metrics.max_abs_euler_deg);
fprintf(fid, 'Rotor speed max [w1 w2 w3 w4] rad/s: %.4f %.4f %.4f %.4f\n', metrics.max_rotor_speed);
fprintf(fid, 'Rotor speed min [w1 w2 w3 w4] rad/s: %.4f %.4f %.4f %.4f\n', metrics.min_rotor_speed);
end

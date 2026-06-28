function outFiles = generate_chapter4_figures()
%GENERATE_CHAPTER4_FIGURES Create missing chapter-4 figures for the report.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
outDir = fullfile(projectRoot, 'docs', 'figures');
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

outFiles = {};
outFiles{end+1} = make_fig4_1(outDir);
outFiles{end+1} = make_fig4_2(outDir);
outFiles{end+1} = make_fig4_3(outDir);
outFiles{end+1} = make_fig4_4(outDir);
outFiles{end+1} = make_fig4_5(outDir);
outFiles{end+1} = make_fig4_6(outDir);
outFiles{end+1} = make_fig4_7(outDir);
outFiles{end+1} = make_fig4_8(outDir);
outFiles{end+1} = make_fig4_9(outDir);
outFiles{end+1} = make_fig4_10(outDir);
outFiles{end+1} = make_fig4_11(outDir);

fprintf('Generated chapter-4 figures in: %s\n', outDir);
for i = 1:numel(outFiles)
    fprintf('%s\n', outFiles{i});
end
end

function pathOut = make_fig4_1(outDir)
fig = new_canvas([1350 760]);
title_banner(fig, 'Fig. 4-1 Modular composition of the 6-DOF UAV simulation system');
boxes = {
    [0.05 0.58 0.12 0.12], 'Guidance', [0.88 0.95 1.00]
    [0.21 0.58 0.12 0.12], 'Position Controller', [0.90 0.97 0.88]
    [0.37 0.58 0.12 0.12], 'Attitude Controller', [1.00 0.93 0.84]
    [0.53 0.58 0.12 0.12], 'Control Allocation', [0.95 0.89 1.00]
    [0.69 0.58 0.12 0.12], 'Propulsion Dynamics', [0.88 0.94 1.00]
    [0.85 0.58 0.10 0.12], '6DOF Dynamics', [0.88 1.00 0.90]
    [0.69 0.28 0.16 0.11], 'Navigation Feedback', [0.96 0.96 0.96]
    [0.22 0.22 0.20 0.12], 'Reference / state / control logging', [0.97 0.97 0.90]
};
for i = 1:size(boxes, 1)
    add_box(fig, boxes{i, 1}, boxes{i, 2}, boxes{i, 3});
end
add_arrow(fig, [0.17 0.21], [0.64 0.64], 'ref_{traj}, yaw');
add_arrow(fig, [0.33 0.37], [0.64 0.64], 'U_1, att_{ref}');
add_arrow(fig, [0.49 0.53], [0.64 0.64], 'control');
add_arrow(fig, [0.65 0.69], [0.64 0.64], 'motor cmd');
add_arrow(fig, [0.81 0.85], [0.64 0.64], 'rotor speed');
add_arrow(fig, [0.90 0.77], [0.58 0.39], 'state');
add_arrow(fig, [0.69 0.33], [0.34 0.34], 'delayed state');
add_arrow(fig, [0.90 0.90], [0.53 0.42], '');
add_arrow(fig, [0.11 0.32], [0.58 0.34], '');
add_arrow(fig, [0.27 0.27], [0.58 0.34], '');
add_arrow(fig, [0.43 0.34], [0.58 0.34], '');
annotation(fig, 'textbox', [0.05 0.10 0.90 0.08], ...
    'String', ['The top level follows the same engineering chain as the Simulink model: ', ...
               'command generation, feedback, control, allocation, propulsion, rigid-body dynamics, and logging.'], ...
    'LineStyle', 'none', 'HorizontalAlignment', 'center', 'FontSize', 11, 'Color', [0.25 0.25 0.25]);
pathOut = save_canvas(fig, fullfile(outDir, 'fig4_1_modular_architecture.png'));
end

function pathOut = make_fig4_2(outDir)
fig = new_canvas([1280 760]);
title_banner(fig, 'Fig. 4-2 Guidance reference trajectory generation module');
add_box(fig, [0.08 0.54 0.12 0.10], 'Time t', [0.95 0.95 0.95]);
add_box(fig, [0.08 0.36 0.12 0.10], 'Mode', [0.95 0.95 0.95]);
add_box(fig, [0.30 0.40 0.22 0.20], {'Quintic planner', 'quintic_segment()', 'smooth lift-off / transition'}, [0.88 0.95 1.00]);
add_box(fig, [0.64 0.52 0.20 0.10], 'ref_{pos}', [0.90 0.98 0.90]);
add_box(fig, [0.64 0.39 0.20 0.10], 'ref_{vel}', [0.90 0.98 0.90]);
add_box(fig, [0.64 0.26 0.20 0.10], 'ref_{acc}', [0.90 0.98 0.90]);
add_box(fig, [0.64 0.13 0.20 0.10], 'ref_{yaw}', [0.90 0.98 0.90]);
add_arrow(fig, [0.20 0.30], [0.59 0.54], '');
add_arrow(fig, [0.20 0.30], [0.41 0.46], '');
add_arrow(fig, [0.52 0.64], [0.56 0.57], '');
add_arrow(fig, [0.52 0.64], [0.50 0.44], '');
add_arrow(fig, [0.52 0.64], [0.44 0.31], '');
add_arrow(fig, [0.52 0.64], [0.40 0.18], '');
annotation(fig, 'textbox', [0.08 0.08 0.48 0.16], ...
    'String', {'Scenario modes', ...
               '1: hover   2: level flight   3: climb   4: lateral shift', ...
               'All trajectories keep position / velocity / acceleration continuous.'}, ...
    'FitBoxToText', 'off', 'BackgroundColor', [1.00 0.99 0.93], 'EdgeColor', [0.90 0.82 0.58], ...
    'FontSize', 11, 'LineWidth', 1.2);
pathOut = save_canvas(fig, fullfile(outDir, 'fig4_2_guidance_module.png'));
end

function pathOut = make_fig4_3(outDir)
t = linspace(0, 20, 2001);
hover = local_ref(t, 1);
level = local_ref(t, 2);
climb = local_ref(t, 3);
lateral = local_ref(t, 4);

fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 80 1280 820]);
tiledlayout(2, 2, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
plot_xyz(t, hover, 'Hover');
nexttile;
plot_xyz(t, level, 'Level flight');
nexttile;
plot_xyz(t, climb, 'Climb');
nexttile;
plot_xyz(t, lateral, 'Lateral shift');

sgtitle('Fig. 4-3 Reference trajectories for the four flight scenarios', 'FontSize', 15, 'FontWeight', 'bold');
pathOut = fullfile(outDir, 'fig4_3_reference_trajectories.png');
exportgraphics(fig, pathOut, 'Resolution', 200);
close(fig);
end

function pathOut = make_fig4_4(outDir)
fig = new_canvas([1220 720]);
title_banner(fig, 'Fig. 4-4 Navigation Feedback module schematic');
add_box(fig, [0.12 0.50 0.18 0.13], {'state', '[x y z vx vy vz', 'phi theta psi p q r]^T'}, [0.88 1.00 0.90]);
add_box(fig, [0.42 0.48 0.18 0.17], {'Unit Delay', 'Ts = 0.01 s', 'avoid algebraic loop'}, [0.96 0.96 0.96]);
add_box(fig, [0.72 0.50 0.18 0.13], {'nav_state', 'controller feedback'}, [0.90 0.98 1.00]);
add_arrow(fig, [0.30 0.42], [0.57 0.57], '');
add_arrow(fig, [0.60 0.72], [0.57 0.57], '');
annotation(fig, 'textbox', [0.18 0.16 0.64 0.16], ...
    'String', ['The feedback block delays the rigid-body state by one sample before feeding it back ', ...
               'to the outer-loop and inner-loop controllers. This keeps the digital closed loop stable and explicit.'], ...
    'LineStyle', 'none', 'HorizontalAlignment', 'center', 'FontSize', 11);
pathOut = save_canvas(fig, fullfile(outDir, 'fig4_4_navigation_feedback_module.png'));
end

function pathOut = make_fig4_5(outDir)
fig = new_canvas([1340 760]);
title_banner(fig, 'Fig. 4-5 Position controller structure');
add_box(fig, [0.05 0.60 0.16 0.12], {'ref_{traj}', '[pos vel acc]'}, [0.90 0.98 1.00]);
add_box(fig, [0.05 0.38 0.16 0.12], {'nav\_state', '[pos vel]'}, [0.90 0.98 1.00]);
add_box(fig, [0.31 0.49 0.18 0.18], {'Error shaping', 'e_p, e_v, \int e_p', 'K_p + K_i + K_d'}, [0.88 0.95 1.00]);
add_box(fig, [0.57 0.49 0.18 0.18], {'acc_{cmd}', 'feedforward + feedback', 'saturation'}, [0.90 0.98 0.90]);
add_box(fig, [0.82 0.60 0.13 0.12], 'U_1', [1.00 0.94 0.88]);
add_box(fig, [0.82 0.38 0.13 0.12], 'att_{ref}', [1.00 0.94 0.88]);
add_arrow(fig, [0.21 0.31], [0.66 0.61], '');
add_arrow(fig, [0.21 0.31], [0.44 0.55], '');
add_arrow(fig, [0.49 0.57], [0.58 0.58], '');
add_arrow(fig, [0.75 0.82], [0.62 0.66], 'thrust channel');
add_arrow(fig, [0.75 0.82], [0.54 0.44], 'attitude mapping');
annotation(fig, 'textbox', [0.15 0.12 0.70 0.13], ...
    'String', ['The outer loop combines reference acceleration with position / velocity feedback, ', ...
               'then converts horizontal acceleration demand into roll and pitch commands.'], ...
    'LineStyle', 'none', 'HorizontalAlignment', 'center', 'FontSize', 11);
pathOut = save_canvas(fig, fullfile(outDir, 'fig4_5_position_controller_structure.png'));
end

function pathOut = make_fig4_6(outDir)
fig = new_canvas([1280 760]);
title_banner(fig, 'Fig. 4-6 Position controller input/output signal relationship');
add_box(fig, [0.37 0.40 0.26 0.20], {'Position Controller', 'Inputs: ref\_traj, nav\_state, ref\_yaw', ...
                                      'Outputs: U_1, att_{ref}, acc_{cmd}, ref\_pos'}, [0.92 0.96 1.00]);
leftBoxes = {
    [0.08 0.63 0.16 0.09], 'ref_{pos}'
    [0.08 0.50 0.16 0.09], 'ref_{vel}'
    [0.08 0.37 0.16 0.09], 'ref_{acc}'
    [0.08 0.24 0.16 0.09], 'nav_{state}'
};
for i = 1:size(leftBoxes, 1)
    add_box(fig, leftBoxes{i, 1}, leftBoxes{i, 2}, [0.95 0.95 0.95]);
    add_arrow(fig, [0.24 0.37], [leftBoxes{i, 1}(2)+0.045 leftBoxes{i, 1}(2)+0.045], '');
end
add_box(fig, [0.08 0.11 0.16 0.09], 'ref_{yaw}', [0.95 0.95 0.95]);
add_arrow(fig, [0.24 0.37], [0.155 0.155], '');
rightBoxes = {
    [0.76 0.61 0.16 0.09], 'U_1'
    [0.76 0.46 0.16 0.09], 'att_{ref}'
    [0.76 0.31 0.16 0.09], 'acc_{cmd}'
    [0.76 0.16 0.16 0.09], 'ref_{pos out}'
};
for i = 1:size(rightBoxes, 1)
    add_box(fig, rightBoxes{i, 1}, rightBoxes{i, 2}, [0.90 0.98 0.90]);
    add_arrow(fig, [0.63 0.76], [rightBoxes{i, 1}(2)+0.045 rightBoxes{i, 1}(2)+0.045], '');
end
pathOut = save_canvas(fig, fullfile(outDir, 'fig4_6_position_io_signals.png'));
end

function pathOut = make_fig4_7(outDir)
fig = new_canvas([1320 760]);
title_banner(fig, 'Fig. 4-7 Attitude controller structure');
add_box(fig, [0.08 0.58 0.16 0.11], 'att_{ref}', [0.90 0.98 1.00]);
add_box(fig, [0.08 0.38 0.16 0.11], 'nav\_state', [0.90 0.98 1.00]);
add_box(fig, [0.34 0.46 0.18 0.18], {'Attitude error', 'wrap yaw error', 'e_{\phi}, e_{\theta}, e_{\psi}'}, [0.88 0.95 1.00]);
add_box(fig, [0.60 0.46 0.18 0.18], {'PD law', '\tau = K_p e - K_d \omega', 'torque saturation'}, [0.90 0.98 0.90]);
add_box(fig, [0.84 0.46 0.12 0.18], {'control', '[U_1 \tau_\phi \tau_\theta \tau_\psi]^T'}, [1.00 0.94 0.88]);
add_arrow(fig, [0.24 0.34], [0.635 0.59], '');
add_arrow(fig, [0.24 0.34], [0.435 0.51], '');
add_arrow(fig, [0.52 0.60], [0.55 0.55], '');
add_arrow(fig, [0.78 0.84], [0.55 0.55], '');
pathOut = save_canvas(fig, fullfile(outDir, 'fig4_7_attitude_controller_structure.png'));
end

function pathOut = make_fig4_8(outDir)
fig = new_canvas([1320 760]);
title_banner(fig, 'Fig. 4-8 Control allocation module structure');
add_box(fig, [0.08 0.44 0.18 0.18], {'control input', '[U_1 \tau_\phi \tau_\theta \tau_\psi]^T'}, [0.90 0.98 1.00]);
add_box(fig, [0.38 0.44 0.22 0.18], {'Allocation matrix', 'w_i^2 = f(U_1,\tau_\phi,\tau_\theta,\tau_\psi)', ...
                                      'nonnegative + upper bound'}, [0.88 0.95 1.00]);
add_box(fig, [0.72 0.44 0.18 0.18], {'sqrt(.) + saturation', 'motor speed command'}, [0.90 0.98 0.90]);
add_box(fig, [0.75 0.18 0.12 0.12], {'motor\_cmd', '[w_1 w_2 w_3 w_4]^T'}, [1.00 0.94 0.88]);
add_arrow(fig, [0.26 0.38], [0.53 0.53], '');
add_arrow(fig, [0.60 0.72], [0.53 0.53], '');
add_arrow(fig, [0.81 0.81], [0.44 0.30], '');
annotation(fig, 'textbox', [0.08 0.10 0.52 0.14], ...
    'String', {'Physical meaning', ...
               'The controller does not command attitude directly; it commands thrust and body torques,', ...
               'which are mapped to four rotor speeds under actuator constraints.'}, ...
    'BackgroundColor', [1.00 0.99 0.93], 'EdgeColor', [0.90 0.82 0.58], 'FontSize', 11);
pathOut = save_canvas(fig, fullfile(outDir, 'fig4_8_control_allocation_structure.png'));
end

function pathOut = make_fig4_9(outDir)
t = linspace(0, 0.8, 600);
tau = 0.10;
cmd = 320 * ones(size(t));
resp = cmd .* (1 - exp(-t / tau));

fig = figure('Visible', 'off', 'Color', 'w', 'Position', [120 100 1000 620]);
plot(t, cmd, 'k--', 'LineWidth', 1.5); hold on;
plot(t, resp, 'b', 'LineWidth', 2.0);
grid on;
xlabel('Time / s');
ylabel('Rotor speed / (rad/s)');
legend('motor command', 'first-order response', 'Location', 'southeast');
title('Fig. 4-9 First-order propulsion response');
text(0.42, 150, '\tau = 0.10 s', 'FontSize', 12, 'BackgroundColor', [1 1 1]);
pathOut = fullfile(outDir, 'fig4_9_propulsion_first_order_response.png');
exportgraphics(fig, pathOut, 'Resolution', 200);
close(fig);
end

function pathOut = make_fig4_10(outDir)
fig = new_canvas([1360 780]);
title_banner(fig, 'Fig. 4-10 6DOF dynamics module structure');
add_box(fig, [0.07 0.58 0.16 0.12], 'rotor\_speed', [0.90 0.98 1.00]);
add_box(fig, [0.07 0.37 0.16 0.12], 'att_{ref} / acc_{cmd}', [0.95 0.95 0.95]);
add_box(fig, [0.32 0.55 0.18 0.18], {'Thrust / torque', 'U_1, \tau_\phi, \tau_\theta, \tau_\psi'}, [0.88 0.95 1.00]);
add_box(fig, [0.58 0.55 0.18 0.18], {'Rigid-body dynamics', 'translation + rotation', 'drag + gravity'}, [0.90 0.98 0.90]);
add_box(fig, [0.58 0.30 0.18 0.14], {'Kinematics', '\dot{euler} = T(euler)\omega'}, [0.95 0.95 0.95]);
add_box(fig, [0.84 0.58 0.12 0.12], 'state', [1.00 0.94 0.88]);
add_box(fig, [0.84 0.36 0.12 0.12], 'accel', [1.00 0.94 0.88]);
add_arrow(fig, [0.23 0.32], [0.64 0.64], '');
add_arrow(fig, [0.23 0.32], [0.43 0.58], '');
add_arrow(fig, [0.50 0.58], [0.64 0.64], '');
add_arrow(fig, [0.67 0.67], [0.55 0.44], '');
add_arrow(fig, [0.76 0.84], [0.64 0.64], '');
add_arrow(fig, [0.76 0.84], [0.40 0.42], '');
pathOut = save_canvas(fig, fullfile(outDir, 'fig4_10_dynamics_structure.png'));
end

function pathOut = make_fig4_11(outDir)
fig = new_canvas([1380 780]);
title_banner(fig, 'Fig. 4-11 Data logging variables and result output relationship');
left = {
    [0.06 0.72 0.18 0.07], 'sim\_time'
    [0.06 0.62 0.18 0.07], 'sim\_ref\_pos'
    [0.06 0.52 0.18 0.07], 'sim\_att\_ref'
    [0.06 0.42 0.18 0.07], 'sim\_control'
    [0.06 0.32 0.18 0.07], 'sim\_motor\_cmd'
    [0.06 0.22 0.18 0.07], 'sim\_rotor\_speed'
    [0.06 0.12 0.18 0.07], 'sim\_state / sim\_accel'
};
for i = 1:size(left, 1)
    add_box(fig, left{i, 1}, left{i, 2}, [0.95 0.95 0.95]);
end
add_box(fig, [0.38 0.36 0.22 0.22], {'plot\_sim\_results.m', 'save .mat', 'write metrics', 'export PNG figures'}, [0.92 0.96 1.00]);
add_box(fig, [0.74 0.60 0.18 0.10], 'state response PNG', [0.90 0.98 0.90]);
add_box(fig, [0.74 0.45 0.18 0.10], 'control / rotor PNG', [0.90 0.98 0.90]);
add_box(fig, [0.74 0.30 0.18 0.10], '3D trajectory PNG', [0.90 0.98 0.90]);
add_box(fig, [0.74 0.15 0.18 0.10], 'metrics TXT + MAT', [0.90 0.98 0.90]);
for y = [0.755 0.655 0.555 0.455 0.355 0.255 0.155]
    add_arrow(fig, [0.24 0.38], [y 0.47], '');
end
add_arrow(fig, [0.60 0.74], [0.61 0.65], '');
add_arrow(fig, [0.60 0.74], [0.54 0.50], '');
add_arrow(fig, [0.60 0.74], [0.47 0.35], '');
add_arrow(fig, [0.60 0.74], [0.40 0.20], '');
pathOut = save_canvas(fig, fullfile(outDir, 'fig4_11_data_logging_relationship.png'));
end

function data = local_ref(t, mode)
x = zeros(size(t)); y = zeros(size(t)); z = 3 * ones(size(t));
vx = zeros(size(t)); vy = zeros(size(t)); vz = zeros(size(t));
ax = zeros(size(t)); ay = zeros(size(t)); az = zeros(size(t));
for k = 1:numel(t)
    tk = t(k);
    if mode < 1.5
        [z(k), vz(k), az(k)] = quintic_segment(tk, 0, 5, 0, 3);
    elseif mode < 2.5
        [z(k), vz(k), az(k)] = quintic_segment(tk, 0, 5, 0, 3);
        [x(k), vx(k), ax(k)] = quintic_segment(tk, 5, 18, 0, 6);
    elseif mode < 3.5
        [z(k), vz(k), az(k)] = quintic_segment(tk, 0, 5, 0, 3);
        [z2, vz2, az2] = quintic_segment(tk, 8, 16, 3, 5);
        if tk >= 8
            z(k) = z2; vz(k) = vz2; az(k) = az2;
        end
    else
        [z(k), vz(k), az(k)] = quintic_segment(tk, 0, 5, 0, 3);
        [y(k), vy(k), ay(k)] = quintic_segment(tk, 5, 17, 0, 3);
    end
end
data = struct('pos', [x(:) y(:) z(:)], 'vel', [vx(:) vy(:) vz(:)], 'acc', [ax(:) ay(:) az(:)]);
end

function [p, v, a] = quintic_segment(t, t0, tf, p0, pf)
if t <= t0
    p = p0; v = 0; a = 0;
elseif t >= tf
    p = pf; v = 0; a = 0;
else
    T = tf - t0;
    s = (t - t0) / T;
    ds = 1 / T;
    h = 10 * s^3 - 15 * s^4 + 6 * s^5;
    hd = (30 * s^2 - 60 * s^3 + 30 * s^4) * ds;
    hdd = (60 * s - 180 * s^2 + 120 * s^3) * ds * ds;
    p = p0 + (pf - p0) * h;
    v = (pf - p0) * hd;
    a = (pf - p0) * hdd;
end
end

function plot_xyz(t, data, titleText)
plot(t, data.pos(:, 1), 'r', 'LineWidth', 1.2); hold on;
plot(t, data.pos(:, 2), 'g', 'LineWidth', 1.2);
plot(t, data.pos(:, 3), 'b', 'LineWidth', 1.2);
grid on;
xlabel('Time / s');
ylabel('Reference position / m');
legend('x', 'y', 'z', 'Location', 'best');
title(titleText);
end

function fig = new_canvas(sizePx)
fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100 80 sizePx(1) sizePx(2)]);
axes('Position', [0 0 1 1], 'Visible', 'off');
end

function title_banner(fig, textStr)
annotation(fig, 'textbox', [0.03 0.90 0.94 0.07], ...
    'String', textStr, 'LineStyle', 'none', 'HorizontalAlignment', 'center', ...
    'FontSize', 16, 'FontWeight', 'bold', 'Color', [0.10 0.20 0.35], ...
    'Interpreter', 'none');
end

function add_box(fig, pos, textStr, faceColor)
annotation(fig, 'textbox', pos, 'String', textStr, ...
    'FitBoxToText', 'off', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
    'FontSize', 11, 'LineWidth', 1.2, 'EdgeColor', [0.35 0.40 0.45], ...
    'BackgroundColor', faceColor, 'Interpreter', 'none');
end

function add_arrow(fig, x, y, labelStr)
annotation(fig, 'arrow', x, y, 'LineWidth', 1.4, 'HeadLength', 7, 'HeadWidth', 7, ...
    'Color', [0.30 0.30 0.35]);
if ~isempty(labelStr)
    xm = mean(x);
    ym = mean(y);
    annotation(fig, 'textbox', [xm - 0.05 ym + 0.01 0.10 0.04], 'String', labelStr, ...
        'LineStyle', 'none', 'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', [0.20 0.20 0.20], ...
        'Interpreter', 'none');
end
end

function pathOut = save_canvas(fig, pathOut)
exportgraphics(fig, pathOut, 'Resolution', 200);
close(fig);
end

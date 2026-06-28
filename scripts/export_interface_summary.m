function export_interface_summary()
%EXPORT_INTERFACE_SUMMARY Write a compact module/interface summary.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
docPath = fullfile(projectRoot, 'docs', 'module_interface_summary.md');
fid = fopen(docPath, 'w', 'n', 'UTF-8');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# 多旋翼无人机六自由度仿真模块接口说明\n\n');
fprintf(fid, '本工程使用 MATLAB/Simulink 实现课程设计要求中的六自由度控制仿真。课程版模型为 `model/uav_6dof_course.slx`，原比赛模型备份在 `source/final_PID_model_original.slx`。\n\n');

fprintf(fid, '## 分系统映射\n\n');
fprintf(fid, '| 老师要求的分系统 | 工程实现 | 说明 |\n');
fprintf(fid, '|---|---|---|\n');
fprintf(fid, '| 气动分系统 | Six-DOF Dynamics | 旋翼升力、反扭矩、线阻尼和角阻尼。 |\n');
fprintf(fid, '| 结构分系统 | init_uav_params / Dynamics 参数 | 质量、转动惯量、机臂长度、旋翼布局参数。 |\n');
fprintf(fid, '| 导航分系统 | Navigation Feedback | 输出位置、速度、姿态角、角速度状态反馈。 |\n');
fprintf(fid, '| 控制分系统 | Position Controller / Attitude Controller / Control Allocation | 外环位置控制、内环姿态控制和电机分配。 |\n');
fprintf(fid, '| 动力分系统 | Propulsion Dynamics | 电机/旋翼一阶响应，输出四个旋翼转速。 |\n\n');

fprintf(fid, '## 模块接口\n\n');
fprintf(fid, '| 模块 | 输入 | 输出 | 功能 |\n');
fprintf(fid, '|---|---|---|---|\n');
fprintf(fid, '| Guidance | 时间 `t`、场景模式 `mode` | 参考位置 `ref_pos`、参考航向 `ref_yaw` | 生成悬停和平飞指令。 |\n');
fprintf(fid, '| Position Controller | `ref_pos`、状态 `state`、`ref_yaw` | 总推力 `U1`、期望姿态 `att_ref` | 根据位置误差生成总推力和姿态指令。 |\n');
fprintf(fid, '| Attitude Controller | `U1`、`att_ref`、状态 `state` | 控制量 `[U1,tau_phi,tau_theta,tau_psi]` | 根据姿态误差生成力矩指令。 |\n');
fprintf(fid, '| Control Allocation | 控制量 | 四电机转速指令 `motor_cmd` | 将总推力/力矩分配为四个旋翼转速。 |\n');
fprintf(fid, '| Propulsion Dynamics | `motor_cmd` | 实际旋翼转速 `rotor_speed` | 模拟电机一阶动态响应。 |\n');
fprintf(fid, '| Six-DOF Dynamics | `rotor_speed` | 状态 `state`、加速度 `accel` | 计算并积分无人机六自由度运动。 |\n');
fprintf(fid, '| Navigation Feedback | `state` | 延迟一拍的 `state` | 避免代数环并形成导航反馈。 |\n\n');

fprintf(fid, '## 状态量定义\n\n');
fprintf(fid, '`state = [x, y, z, vx, vy, vz, phi, theta, psi, p, q, r]^T`。\n\n');
fprintf(fid, '其中位置单位为 m，速度单位为 m/s，欧拉角单位为 rad，角速度单位为 rad/s。\n\n');

fprintf(fid, '## 验证工况\n\n');
fprintf(fid, '| 工况 | 场景模式 | 目标 |\n');
fprintf(fid, '|---|---:|---|\n');
fprintf(fid, '| 悬停 | 1 | 在 `(0,0,3)m` 附近稳定悬停，姿态角收敛到小角度。 |\n');
fprintf(fid, '| 平飞 | 2 | 沿 `x` 方向前进至约 `6m`，同时保持高度 `z=3m` 和航向稳定。 |\n');
end

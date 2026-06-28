# 多旋翼无人机六自由度仿真模块接口说明

本工程使用 MATLAB/Simulink 实现课程设计要求中的六自由度控制仿真。课程版模型为 `model/uav_6dof_course.slx`，原比赛模型备份在 `source/final_PID_model_original.slx`。

## 分系统映射

| 老师要求的分系统 | 工程实现 | 说明 |
|---|---|---|
| 气动分系统 | Six-DOF Dynamics | 旋翼升力、反扭矩、线阻尼和角阻尼。 |
| 结构分系统 | init_uav_params / Dynamics 参数 | 质量、转动惯量、机臂长度、旋翼布局参数。 |
| 导航分系统 | Navigation Feedback | 输出位置、速度、姿态角、角速度状态反馈。 |
| 控制分系统 | Position Controller / Attitude Controller / Control Allocation | 外环位置控制、内环姿态控制和电机分配。 |
| 动力分系统 | Propulsion Dynamics | 电机/旋翼一阶响应，输出四个旋翼转速。 |

## 模块接口

| 模块 | 输入 | 输出 | 功能 |
|---|---|---|---|
| Guidance | 时间 `t`、场景模式 `mode` | 参考位置 `ref_pos`、参考航向 `ref_yaw` | 生成悬停和平飞指令。 |
| Position Controller | `ref_pos`、状态 `state`、`ref_yaw` | 总推力 `U1`、期望姿态 `att_ref` | 根据位置误差生成总推力和姿态指令。 |
| Attitude Controller | `U1`、`att_ref`、状态 `state` | 控制量 `[U1,tau_phi,tau_theta,tau_psi]` | 根据姿态误差生成力矩指令。 |
| Control Allocation | 控制量 | 四电机转速指令 `motor_cmd` | 将总推力/力矩分配为四个旋翼转速。 |
| Propulsion Dynamics | `motor_cmd` | 实际旋翼转速 `rotor_speed` | 模拟电机一阶动态响应。 |
| Six-DOF Dynamics | `rotor_speed` | 状态 `state`、加速度 `accel` | 计算并积分无人机六自由度运动。 |
| Navigation Feedback | `state` | 延迟一拍的 `state` | 避免代数环并形成导航反馈。 |

## 状态量定义

`state = [x, y, z, vx, vy, vz, phi, theta, psi, p, q, r]^T`。

其中位置单位为 m，速度单位为 m/s，欧拉角单位为 rad，角速度单位为 rad/s。

## 验证工况

| 工况 | 场景模式 | 目标 |
|---|---:|---|
| 悬停 | 1 | 在 `(0,0,3)m` 附近稳定悬停，姿态角收敛到小角度。 |
| 平飞 | 2 | 沿 `x` 方向前进至约 `6m`，同时保持高度 `z=3m` 和航向稳定。 |

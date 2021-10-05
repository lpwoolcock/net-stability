function [] = branch_RL_setup(base, branch_RL_name, branch_RL_params)
    set_param(branch_RL_name, 'R', num2str(base.Z * branch_RL_params.R));
    set_param(branch_RL_name, 'L', num2str(base.L * branch_RL_params.L));
end
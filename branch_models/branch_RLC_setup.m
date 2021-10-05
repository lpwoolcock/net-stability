function [] = branch_RLC_setup(base, branch_RLC_name, branch_RLC_params)
    set_param(branch_RLC_name, 'R', num2str(base.Z * branch_RLC_params.R));
    set_param(branch_RLC_name, 'L', num2str(base.L * branch_RLC_params.L));
    set_param(branch_RLC_name, 'C', num2str(base.C * branch_RLC_params.C));
end
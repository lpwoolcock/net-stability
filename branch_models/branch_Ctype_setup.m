function [] = branch_Ctype_setup(base, branch_name, branch_params)
    set_param(branch_name, 'R', num2str(base.Z * branch_params.R));
    set_param(branch_name, 'L', num2str(base.L * branch_params.L));
    set_param(branch_name, 'C', num2str(base.C * branch_params.C));
    set_param(branch_name, 'C1', num2str(base.C * branch_params.C1));
end
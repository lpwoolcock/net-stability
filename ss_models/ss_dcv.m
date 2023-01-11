function [A_dc, B_dc, C_dc, D_dc] = ss_dcv(k_p_dcv, k_i_dcv)
    % input: [v_b_prime; i_c_prime; v_dc]
    % output: [i_c_ref_prime(1)]

    A_dc = 0;
    B_dc = [0,0,0,0,k_i_dcv];
    C_dc = 1;
    D_dc = [0,0,0,0,k_p_dcv];
end
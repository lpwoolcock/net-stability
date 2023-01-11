function [A_ac, B_ac, B_ac_pll, C_ac, D_ac, D_ac_pll] = ss_acv(k_p_acv, k_i_acv, k_droop, i_c_prime_bar)
    % input: [v_b_prime; i_c_prime; v_dc]
    %      : [delta, omega_twiddle]
    % output: [i_c_ref_prime(1)]

    A_ac = 0;
    B_ac = k_i_acv * [-1,0,0,k_droop,0];
    B_ac_pll = k_i_acv * [-k_droop*i_c_prime_bar(1),0];
    C_ac = -1;
    D_ac = -k_p_acv * [-1,0,0,k_droop,0];
    D_ac_pll = -k_p_acv * [-k_droop*i_c_prime_bar(1),0];
end
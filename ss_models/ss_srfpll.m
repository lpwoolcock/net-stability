function [A_pll, B_pll, C_pll, D_pll] = ss_srfpll(k_p_pll, k_i_pll, v_0)
    A_pll = [-k_p_pll*v_0 1;
             -k_i_pll*v_0 0];
    B_pll = [0 k_p_pll 0 0;
             0 k_i_pll 0 0];
    C_pll = [1            0;
             -k_p_pll*v_0 1];
    D_pll = [0 0       0 0;
             0 k_p_pll 0 0];
end


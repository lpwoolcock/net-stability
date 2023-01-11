function [A_c, B_c, C_c, D_c] = ss_vsc_ctrl_pqff(base, params, v_0)
    i_c_bar = [params.P0; -params.Q0] / v_0;

    [Ap, Bpb, Bpc, ~, Cpc, ~, ~, Dpcb, Dpcc] = ss_vsc_plant(base, params);
    Gcb0 = Dpcb - Cpc * inv(Ap) * Bpb;
    Gcc0 = Dpcc - Cpc * inv(Ap) * Bpc;
    v_c_bar = inv(Gcc0(3:4, :)) * (i_c_bar - Gcb0(3:4, :) * [v_0; 0]);

    [A_pll, B_pll, C_pll, D_pll] = ss_srfpll(params.K_p_pll, params.K_i_pll, v_0);
    [A_pq, B_pq, B_pq_pll, C_pq, D_pq, D_pq_pll] = ss_pq(params.tau_rms, i_c_bar);
    [A_acc, B_acc, B_acc_pll,  B_acc_pq,...
    C_acc, D_acc, D_acc_pll, D_acc_pq] =...
    ss_acc(params.Lf*params.K_p_acc, params.Lf*params.K_i_acc,...
           [0 -params.Lf; params.Lf 0],...
           v_c_bar, [v_0; 0], i_c_bar);

    n_pll = size(A_pll, 1);
    n_pq = size(A_pq, 1);
    n_acc = size(A_acc, 1);
    A_c = [A_pll,                                 zeros(n_pll, n_pq), zeros(n_pll, n_acc);
           B_pq_pll*C_pll,                        A_pq,               zeros(n_pq, n_acc);
           (B_acc_pq*D_pq_pll + B_acc_pll)*C_pll, B_acc_pq*C_pq,      A_acc];
    B_c = [B_pll;
           B_pq_pll*D_pll + B_pq;
           (B_acc_pq*D_pq_pll+B_acc_pll)*D_pll + B_acc_pq*D_pq + B_acc];
    C_c = [(D_acc_pq*D_pq_pll+D_acc_pll)*C_pll, D_acc_pq*C_pq, C_acc];
    D_c = (D_acc_pq*D_pq_pll+D_acc_pll)*D_pll + D_acc_pq*D_pq + D_acc;
end


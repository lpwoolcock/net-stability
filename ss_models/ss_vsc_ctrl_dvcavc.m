function [A_c, B_c, C_c, D_c, i_c_bar, v_c_bar] = ss_vsc_ctrl_dvcavc(base, params, v_0)
    i_c_bar = [params.Psrc/v_0; (v_0-params.Vref)/params.K_droop];

    [Ap, Bpb, Bpc, ~, Cpc, ~, ~, Dpcb, Dpcc] = ss_vsc_plant(base, params);
    Gcb0 = Dpcb - Cpc * inv(Ap) * Bpb;
    Gcc0 = Dpcc - Cpc * inv(Ap) * Bpc;
    v_c_bar = inv(Gcc0(3:4, :)) * (i_c_bar - Gcb0(3:4, :) * [v_0; 0]);

    [A_pll, B_pll, C_pll, D_pll] = ss_srfpll(params.K_p_pll, params.K_i_pll, v_0);
    
    [A_dc, B_dc, C_dc, D_dc] = ss_dcv(params.K_p_dvc, params.K_i_dvc);
    [A_ac, B_ac, B_ac_pll, C_ac, D_ac, D_ac_pll] =...
        ss_acv(params.K_p_avc, params.K_i_avc, params.K_droop, i_c_bar);

    [A_acc, B_acc, B_acc_pll,  B_acc_ref,...
    C_acc, D_acc, D_acc_pll, D_acc_ref] =...
    ss_acc(params.Lf*params.K_p_acc, params.Lf*params.K_i_acc,...
           [0 -params.Lf; params.Lf 0],...
           v_c_bar, [v_0; 0], i_c_bar);

    n_pll = size(A_pll, 1);
    n_ac = size(A_ac, 1);
    n_dc = size(A_ac, 1);
    n_acc = size(A_acc, 1);

    J = [0 -1; 1 0];

    A_c = [A_pll, zeros(n_pll, n_ac+n_dc+n_acc);
           zeros(n_dc, n_pll), A_dc, zeros(n_dc, n_ac+n_acc);
           B_ac_pll*C_pll, zeros(n_ac, n_dc), A_ac, zeros(n_ac, n_acc);
           B_acc_pll*C_pll + B_acc_ref*([0;1]*D_ac_pll*C_pll+J*i_c_bar*[1,0]*C_pll),...
           B_acc_ref*[1;0]*C_dc, B_acc_ref*[0;1]*C_ac, A_acc];
    B_c = [B_pll, [0;0]; B_dc; B_ac+[B_ac_pll*D_pll, 0];
        [B_acc+B_acc_pll*D_pll, [0;0]] +...
        B_acc_ref * ([1;0]*D_dc+[0;1]*(D_ac+[D_ac_pll*D_pll,0])+[J*i_c_bar*[1,0]*D_pll, [0;0]])];

    C_c = [D_acc_pll*C_pll + D_acc_ref*([0;1]*D_ac_pll*C_pll+J*i_c_bar*[1,0]*C_pll),...
           D_acc_ref*[1;0]*C_dc, D_acc_ref*[0;1]*C_ac, C_acc];
    D_c = [D_acc+D_acc_pll*D_pll, [0;0]] +...
        D_acc_ref * ([1;0]*D_dc+[0;1]*(D_ac+[D_ac_pll*D_pll,0])+[J*i_c_bar*[1,0]*D_pll, [0;0]]);
%{
    A_c = [A_pll, zeros(n_pll, n_ac);
           B_ac_pll*C_pll, A_ac];
    B_c = [B_pll, [0;0];
           B_ac + B_ac_pll*[D_pll, [0;0]]];
    C_c = [D_ac_pll*C_pll, C_ac];
    D_c = D_ac + D_ac_pll*[D_pll, [0;0]];
%}
end


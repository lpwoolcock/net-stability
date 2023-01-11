function [Ap, Bpb, Bpc, Cpb, Cpc, Dpbb, Dpbc, Dpcb, Dpcc] = ss_vsc_plant_dc(base, params, i_c_bar, v_c_bar)
    [Af_prime, Bfb, Bfc, Cfb, Cfc, Dfbb, Dfbc, Dfcb, Dfcc] = ss_l_filter(params.Lf / base.omega, params.Rf, base.omega);
    [Ad_prime, Bd, Cd, Dd] = ss_pade(params.tau_d, 3, base.omega);

    [Adc, Bdcv, Bdci] = ss_dclink(params.Cdc/base.omega, 1.0, v_c_bar, i_c_bar);

    nf = size(Af_prime, 1);
    nd = size(Ad_prime, 1);
    ndc = size(Adc, 1);

    Ap = [Af_prime,      Bfc*Cd,              zeros(nf, ndc);
          zeros(nd, nf), Ad_prime,            zeros(nd, ndc);
          Bdci*Cfc,      (Bdci*Dfcc+Bdcv)*Cd, Adc];

    Bpb = [Bfb; zeros(nd, 2); Bdci*Dfcb];
    Bpc = [Bfc*Dd; Bd; (Bdcv+Bdci*Dfcc)*Dd];

    Cpb = [Cfb, Dfbc*Cd, zeros(2, ndc)];
    Cpc = [zeros(2, nd+nf+ndc);
           Cfc, Dfcc*Cd, zeros(2, ndc);
           zeros(1, nf+nd) 1];

    Dpbb = Dfbb;
    Dpbc = Dfbc * Dd;
    Dpcb = [eye(2); Dfcb; zeros(1, 2)];
    Dpcc = [zeros(2); Dfcc*Dd; zeros(1, 2)];
end

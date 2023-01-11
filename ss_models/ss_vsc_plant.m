function [Ap, Bpb, Bpc, Cpb, Cpc, Dpbb, Dpbc, Dpcb, Dpcc] = ss_vsc_plant(base, params)
    [Af_prime, Bfb, Bfc, Cfb, Cfc, Dfbb, Dfbc, Dfcb, Dfcc] = ss_l_filter(params.Lf / base.omega, params.Rf, base.omega);
    [Ad_prime, Bd, Cd, Dd] = ss_pade(params.tau_d, 3, base.omega);

    nf = size(Af_prime, 1);
    nd = size(Ad_prime, 1);

    Ap = [Af_prime,      Bfc*Cd;
          zeros(nd, nf), Ad_prime];

    Bpb = [Bfb; zeros(nd, 2)];
    Bpc = [Bfc*Dd; Bd];

    Cpb = [Cfb, Dfbc*Cd];
    Cpc = [zeros(2, nd+nf);
           Cfc, Dfcc*Cd];

    Dpbb = Dfbb;
    Dpbc = Dfbc * Dd;
    Dpcb = [eye(2); Dfcb];
    Dpcc = [zeros(2); Dfcc*Dd];
end

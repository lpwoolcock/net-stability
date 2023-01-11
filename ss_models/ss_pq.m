function [A_pq, B_pq, B_pq_pll, C_pq, D_pq, D_pq_pll] = ss_pq(tau_f, i_bar)
    A_pq = -1/tau_f;
    B_pq = [1/tau_f 0 0 0];
    B_pq_pll = [0 0];
    C_pq = -i_bar;
    D_pq = zeros(2,4);
    D_pq_pll = [[0 -1; 1 0] * i_bar zeros(2,1)];
end
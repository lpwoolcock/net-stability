function [Ad_prime, Bd, Cd, Dd] = ss_pade(tau, n, omega_bar)
    [N, D] = pade(tau, n);
    G = canon(tf(N, D), 'modal');
    n = size(G.A, 1);

    I2 = eye(2);
    J = [0 -1; 1 0];
    Ad_prime = kron(G.A, I2) - kron(eye(n), J*omega_bar);
    Bd = kron(G.B, I2);
    Cd = kron(G.C, I2);
    Dd = kron(G.D, I2);
end


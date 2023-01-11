function [Af_prime, Bfb, Bfc, Cfb, Cfc, Dfbb, Dfbc, Dfcb, Dfcc] = ss_l_filter(Lf, Rf, omega_bar)
    I2 = eye(2);
    J = [0 -1; 1 0];

    Af_prime = -Rf/Lf * I2 - omega_bar * J;
    Bfb = -1/Lf * I2;
    Bfc = 1/Lf * I2;
    Cfb = I2;
    Cfc = I2;
    Dfbb = zeros(2);
    Dfbc = zeros(2);
    Dfcb = zeros(2);
    Dfcc = zeros(2);
end


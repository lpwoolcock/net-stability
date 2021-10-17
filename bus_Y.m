function [Y] = bus_Y(Yg, bus_k)
    % find admittance seen at bus k assuming nothing else connected

    N = size(Yg, 1);
    M = size(Yg, 3);

    % we set the voltage at bus k
    % all other voltages are unknown.
    Q = zeros(N);
    Q(2*bus_k-1:2*bus_k, 2*bus_k-1:2*bus_k) = eye(2);

    % we want to measure the current at bus k
    % all other currents are known - set to zero.
    P = eye(N);
    P(2*bus_k-1:2*bus_k, 2*bus_k-1:2*bus_k) = zeros(2);

    % we have a N-length vector of knowns, K = PI + QV
    K = zeros(N,1);

    K(2*bus_k-1) = 1; % set Vd=1,Vq=0 at bus_k

    % now we want current bus bus_k. I = (P+QZ)^-1 K
    Zg = pageinv(Yg);

    I = pagemtimes(pageinv(P + pagemtimes(Q, Zg)), K);
    Y = zeros([2 2 M]);
    Y(:, 1, :) = I(2*bus_k-1:2*bus_k, 1, :);

    K(2*bus_k-1) = 0; % set Vd=0,Vq=1 at bus_k
    K(2*bus_k) = 1;

    I = pagemtimes(pageinv(P + pagemtimes(Q, Zg)), K);
    Y(:, 2, :) = I(2*bus_k-1:2*bus_k, 1, :);
end

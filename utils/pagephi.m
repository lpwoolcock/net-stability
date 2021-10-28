function [phi_inf] = pagephi(C)
    E = pagemtimes(C, pageinv(pagectranspose(C)));
    
    M = size(C,3);
    N = size(C,1);

    phi = zeros(N, M);

    K = 3 ^ N;
    wrap_vector = zeros(N, K);
    for k = 1:K
        base_str = dec2base(k-1, 3, N);
        for l = 1:N
            wrap_vector(l, k) = -pi + pi * str2double(base_str(l));
        end
    end

    phi(:, 1) = angle(eig(E(:,:,k)));
    for k=2:M
        phi2 = perms(angle(eig(E(:,:,k))))';
        delta_phi = wrapToPi(phi2 - phi(:,k-1));

        [~, i] = min(max(abs(delta_phi), [], 1));

        phi(:,k) = phi2(:, i);

    end

    phi = unwrap(phi, [], 2) / 2;

    phi_inf = zeros(2, M);
    phi_inf(1, :) = min(phi, [], 1);
    phi_inf(2, :) = max(phi, [], 1);
end
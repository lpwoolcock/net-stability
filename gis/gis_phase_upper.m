function [phi_lo, phi_hi] = gis_phase_upper(G)
    N = size(G,3);

    phi_lo = zeros(N,1);
    phi_hi = zeros(N,1);

    for k = 1:N
        P = diag([sqrt(abs(G(1,2,k))), sqrt(abs(G(2,1,k)))]);
        phi = matphase(P \ G(:,:,k) * P);

        if isnan(phi)
            phi_hi(k) = nan;
            phi_lo(k) = nan;
        else
            phi_hi(k) = phi(1);
            phi_lo(k) = phi(2);
        end
    end

end


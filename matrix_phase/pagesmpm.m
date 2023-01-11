function [H] = pagesmpm(G, struc)
    n = size(G, 1);
    m = size(G, 3);

    % check that structure conforms to matrix size
    if abs(sum(struc)-n) > 1e2*eps
        error('Invalid structure')
    end
    p = length(struc);

    I2 = eye(2);
    J2 = [0 -1; 1 0];

    % generate pagewise realified matrices
    G_re = zeros(2*n, 2*n, m);
    jG_re = zeros(2*n, 2*n, m);
    for k = 1:m
        G_re(:, :, k) = kron(real(G(:,:,k)), I2) + kron(imag(G(:,:,k)), J2);
        jG_re(:, :, k) = kron(imag(G(:,:,k)), -I2) + kron(real(G(:,:,k)), J2);
    end

    % set up real decision variables
    C_dv = [];
    for k = 1:p
        a = 2*k - 1;
        b = 2*k;
        for r = 1:struc(k)
            C_dv = blkdiag(C_dv, [a -b; b a]);
        end
    end

    H = zeros(n, n, m);
    for k = 1:m
        setlmis([]);
        C = lmivar(3, C_dv);

        % I < Re[MC]
        lmiterm([1 1 1 0], 1);
        lmiterm([-1 1 1 C], G_re(:,:,k), 1, 's');

        % Im[MC] < gamma Re[MC]
        lmiterm([ 2 1 1 C], jG_re(:,:,k), 1, 's');
        lmiterm([-2 1 1 C], G_re(:,:,k), 1, 's');

        % -Im[MC] < gamma Re[MC]
        lmiterm([ 3 1 1 C], -jG_re(:,:,k), 1, 's');
        lmiterm([-3 1 1 C], G_re(:,:,k), 1, 's');

        lmisys = getlmis;
        [gamma, copt] = gevp(lmisys, 2, [0,0,0,0,1]);

        if isempty(gamma)
            % infeasible
            H(:,:,k) = NaN(n, n);
        else
            x = [];
            for r = 1:p
                x = [x; repmat(copt(2*r - 1) + 1j*copt(2*r), [struc(r) 1])];
            end
            H(:,:,k) = diag(x);
        end
    end

end
function Yg = gen_Yg(lin_case)
    N = length(lin_case.op_pt.buses);
    M = length(lin_case.omega_grid);
    Yg = zeros(2*N, 2*N, M);

    for branch = lin_case.branches
        if branch.bus1 == branch.bus2
            % ??? should we error out
            continue;
        elseif branch.bus1 <= 0 || branch.bus2 <= 0
            for p = 1:M
                bus = max(branch.bus1, branch.bus2);
                k = find(lin_case.op_pt.buses == bus, 1);
    
                Yg(2*k-1:2*k, 2*k-1:2*k, p) = Yg(2*k-1:2*k, 2*k-1:2*k, p) + branch.Ydq(:,:,p);
            end
        else
            for p = 1:M
                n = find(lin_case.op_pt.buses == branch.bus1, 1);
                m = find(lin_case.op_pt.buses == branch.bus2, 1);
    
                Yg(2*n-1:2*n, 2*n-1:2*n,p) = Yg(2*n-1:2*n, 2*n-1:2*n,p) + branch.Ydq(:,:,p);
                Yg(2*m-1:2*m, 2*m-1:2*m,p) = Yg(2*m-1:2*m, 2*m-1:2*m,p) + branch.Ydq(:,:,p);
    
                Yg(2*m-1:2*m, 2*n-1:2*n,p) = Yg(2*m-1:2*m, 2*n-1:2*n,p) - branch.Ydq(:,:,p);
                Yg(2*n-1:2*n, 2*m-1:2*m,p) = Yg(2*n-1:2*n, 2*m-1:2*m,p) - branch.Ydq(:,:,p);
            end
        end
    end

end


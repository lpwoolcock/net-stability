function [lin_case] = linearise_case(nl_case, omega_grid)
    op_pt = powerflow(nl_case);
    lin_case.base = nl_case.base;
    lin_case.op_pt = op_pt;
    lin_case.omega_grid = omega_grid;

    for k = 1:length(nl_case.branches)
        % TODO: consider dealing with op pt. for nonlinear branches?

        %lin_case.branches(k).Ydq = Ydq_noise(nl_case.base, nl_case.branches(k), ...
        %    1.0, 1.0, 0.02, omega_grid, 30);

        Ys = 1/branch_get_Z(nl_case.branches(k), 's');
        lin_case.branches(k).Ydq = tf_s2dq(Ys, omega_grid, 1);

        lin_case.branches(k).bus1 = nl_case.branches(k).bus1;
        lin_case.branches(k).bus2 = nl_case.branches(k).bus2;
    end

    for k = 1:length(nl_case.devices)
        bus_k = find(op_pt.buses == nl_case.devices(k).bus, 1);

        %lin_case.devices(k).Ydq = Ydq_noise(nl_case.base, nl_case.devices(k), ...
        %    op_pt.V(bus_k), 1.0, 0.02, omega_grid, 180);
        
        lin_case.devices(k).Ydq = Ydq_extract(nl_case.base, nl_case.devices(k), op_pt.V(bus_k), 1.0, 0.02, omega_grid);
        
        lin_case.devices(k).bus = nl_case.devices(k).bus;
    end

end


function Yd = gen_Yd(lin_case)
    N = length(lin_case.op_pt.buses);
    M = length(lin_case.omega_grid);
    Yd = zeros(2*N, 2*N, M);
    
    
    for device = lin_case.devices
        for m = 1:M
            k = find(lin_case.op_pt.buses == device.bus, 1);
    
            Yd(2*k-1:2*k, 2*k-1:2*k, m) = Yd(2*k-1:2*k, 2*k-1:2*k, m) +...
                Ydq_rotate(device.Ydq(:,:,m), lin_case.op_pt.theta(k));
        end
    end
end


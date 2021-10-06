function [Ydq] = Ydq_noise(base, branch, V0, omega0, V_p, omega_grid, t_meas)
    % base: per unit base value struct (see setup_base)
    % branch: branch or device parameters
    % V0: per unit synchronous voltage
    % omega0: per unit synchronous frequency
    % V_p: per unit perurbation voltage amplitude
    % omega_grid: per unit frequency sampling points
    
    parts = split(branch.type, '_');
    if strcmp(parts{1}, 'branch')
        is_branch = true;
    elseif strcmp(parts{1}, 'device')
        is_branch = false;
    else
        error('Invalid branch/device ID');
    end
    
    
    % add branch block and set parameters
    close_system('Ydq_noise_model',0);
    load_system('Ydq_noise_model');
    
    if is_branch
        branch_lib_name = strcat('branch_library/', branch.type);
    else
        branch_lib_name = strcat('device_library/', branch.type);
    end
    branch_name = 'Ydq_noise_model/branch';
    
    branch_setup_name = strcat(branch.type, '_setup');
    branch_setup = str2func(branch_setup_name);
    
    add_block(branch_lib_name, branch_name);
    
    branch_setup(base, branch_name, branch.params);
    

    % position and connect branch block
    pos_gnd = get_param('Ydq_noise_model/gnd', 'position');
    pos_meas = get_param('Ydq_noise_model/meas', 'position');
    
    pos_branch = (pos_gnd+pos_meas) * 0.5;
    pos_branch(3) = pos_branch(1) + 50;
    pos_branch(4) = pos_branch(2) + 50;
    set_param('Ydq_noise_model/branch', 'position', pos_branch);
    
    meas_RConn = get_param('Ydq_noise_model/meas', 'PortHandles').RConn;
    
    branch_LConn = get_param('Ydq_noise_model/branch', 'PortHandles').LConn;
    if is_branch
        branch_RConn = get_param('Ydq_noise_model/branch', 'PortHandles').RConn;
    end
    
    gnd_Conn = get_param('Ydq_noise_model/gnd', 'PortHandles').LConn;
    
    for k = 1:3
        add_line('Ydq_noise_model', meas_RConn(k), branch_LConn(k));
        
        if is_branch
            add_line('Ydq_noise_model', branch_RConn(k), gnd_Conn);
        end
    end
    
    % save as temp model
    close_system('Ydq_noise_model_tmp',0);
    save_system('Ydq_noise_model', 'Ydq_noise_model_tmp');
    
    % should this change per model?
    t_start = 0.25;

    t_end = t_start + t_meas;

    simin = Simulink.SimulationInput('Ydq_noise_model_tmp');
    simin = simin.setVariable('base', base);
    simin = simin.setVariable('t_end', t_end);
    simin = simin.setVariable('V_p', [V_p 0 0]);
    simin = simin.setVariable('V0', V0);
    simin = simin.setVariable('omega0', omega0);
    
    simin(2) = simin.setVariable('V_p', [0 V_p 0]);
    simout = parsim(simin);

    T = simout(1).Vd.Time(2) - simout(1).Vd.Time(1);
    n_start = find(simout(1).Vd.Time - t_start > 0, 1);
    
    Vd_fft_2 = fft(simout(1).Vd.Data(n_start:end));
    Vd_fft = fft_2_to_1(Vd_fft_2);
    Vq_fft = fft_2_to_1(fft(simout(2).Vq.Data(n_start:end)));
    Idd_fft = fft_2_to_1(fft(simout(1).Id.Data(n_start:end)));
    Iqd_fft = fft_2_to_1(fft(simout(1).Iq.Data(n_start:end)));
    Idq_fft = fft_2_to_1(fft(simout(2).Id.Data(n_start:end)));
    Iqq_fft = fft_2_to_1(fft(simout(2).Iq.Data(n_start:end)));
    
    N = length(Vd_fft_2);
    K = length(Vd_fft);
    omega_fft = ((1:K)-1) / (N*T*base.f);

    Y_dd = Idd_fft ./ Vd_fft;
    Y_qd = Iqd_fft ./ Vd_fft;
    Y_dq = Idq_fft ./ Vq_fft;
    Y_qq = Iqq_fft ./ Vq_fft;

    % resampling operation
    delta_omega_grid = omega_grid(2) - omega_grid(1); % note only uniform frequency sampling is allowed
    delta_omega_fft = omega_fft(2) - omega_fft(1);

    R = delta_omega_fft / delta_omega_grid;

    % choice of filter cutoff is compromise. choosing R allows some
    % aliasing/leakage, choosing low oversmooths

    Y_dd_filt = lowpass(Y_dd, R);
    Y_qd_filt = lowpass(Y_qd, R);
    Y_dq_filt = lowpass(Y_dq, R);
    Y_qq_filt = lowpass(Y_qq, R);

    Ydq = zeros(2,2,length(omega_grid));

    for k = 1:length(omega_grid)
        % will cause rounding error for larger R
        n = find(omega_fft - omega_grid(k) > 0, 1);
        Ydq(:,:,k) = [Y_dd_filt(n), Y_dq_filt(n); Y_qd_filt(n), Y_qq_filt(n)];
    end
end


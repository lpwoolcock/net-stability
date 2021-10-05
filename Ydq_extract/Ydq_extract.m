function [Ydq] = Ydq_extract(base, branch, V0, omega0, V_p, omega_grid)
    % base: per unit base value struct (see setup_base)
    % branch: branch or device parameters
    % V0: per unit synchronous voltage
    % omega0: per unit synchronous frequency
    % V_p: per unit perurbation voltage amplitude
    % omega_grid: per unit frequency sampling points
    
    % TODO: add operating point settings, such as voltage, synch. freq.,
    % perturbation amplitude
    
    % add branch block and set parameters
    close_system('Ydq_extract_model',0);
    load_system('Ydq_extract_model');
    
    branch_lib_name = strcat('branch_library/', branch.type);
    branch_name = 'Ydq_extract_model/branch';
    
    branch_setup_name = strcat(branch.type, '_setup');
    branch_setup = str2func(branch_setup_name);
    
    add_block(branch_lib_name, branch_name);
    
    branch_setup(base, branch_name, branch.params);
    

    % position and connect branch block
    pos_gnd = get_param('Ydq_extract_model/gnd', 'position');
    pos_meas = get_param('Ydq_extract_model/meas', 'position');
    
    pos_branch = (pos_gnd+pos_meas) * 0.5;
    pos_branch(3) = pos_branch(1) + 50;
    pos_branch(4) = pos_branch(2) + 50;
    set_param('Ydq_extract_model/branch', 'position', pos_branch);
    
    meas_RConn = get_param('Ydq_extract_model/meas', 'PortHandles').RConn;
    branch_LConn = get_param('Ydq_extract_model/branch', 'PortHandles').LConn;
    branch_RConn = get_param('Ydq_extract_model/branch', 'PortHandles').RConn;
    gnd_Conn = get_param('Ydq_extract_model/gnd', 'PortHandles').LConn;
    
    for k = 1:3
        add_line('Ydq_extract_model', meas_RConn(k), branch_LConn(k));
        add_line('Ydq_extract_model', branch_RConn(k), gnd_Conn);
    end
    
    % save as temp model
    close_system('Ydq_extract_model_tmp',0);
    save_system('Ydq_extract_model', 'Ydq_extract_model_tmp');
    
    
    N = length(omega_grid);
    % should this change per model?
    t_meas = 1;
    t_start = 0.25;

    omega_p = base.omega * omega_grid;
    f_p = base.f * omega_grid;
    
    for k = 1:N
        N_meas = ceil(f_p(k) * t_meas);
        t_end = t_start + N_meas / f_p(k);
        
        simin(k) = Simulink.SimulationInput('Ydq_extract_model_tmp');
        simin(k) = simin(k).setVariable('base', base);
        simin(k) = simin(k).setVariable('t_end', t_end);
        simin(k) = simin(k).setVariable('omega_p', omega_p(k));
        simin(k) = simin(k).setVariable('V_p', [V_p 0 0]);
        simin(k) = simin(k).setVariable('V0', V0);
        simin(k) = simin(k).setVariable('omega0', omega0);
    end


    simout_d = parsim(simin);
    
    for k = 1:N
        simin(k) = simin(k).setVariable('V_p', [0 V_p 0]);
    end
    
    simout_q = parsim(simin);
    
    Ydq = zeros(2,2,N);
    
    for k = 1:N
        [Id_phasor, Iq_phasor] = DFT(simout_d(k).Id, simout_d(k).Iq, t_start, f_p(k));
        Ydq(1,1,k) = Id_phasor / V_p;
        Ydq(2,1,k) = Iq_phasor / V_p;

        [Id_phasor, Iq_phasor] = DFT(simout_q(k).Id, simout_q(k).Iq, t_start, f_p(k));
        Ydq(1,2,k) = Id_phasor / V_p;
        Ydq(2,2,k) = Iq_phasor / V_p;
    end
    
    close_system('Ydq_extract_model_tmp',0);
end


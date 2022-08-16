function [] = device_SH_inverter_setup(base, device_name, device_params)
    % filter params in p.u.
    set_param(device_name, 'Rf', num2str(device_params.Rf));
    set_param(device_name, 'Lf', num2str(device_params.Lf));

    % PQ setpoint
    set_param(device_name, 'P0', num2str(device_params.P0));
    set_param(device_name, 'Q0', num2str(device_params.Q0));

    % voltage magnitude filter time constant
    set_param(device_name, 'tau_rms', num2str(device_params.tau_rms));
    
    % PLL PI gains for error in p.u. voltage and state in radians
    set_param(device_name, 'K_p_pll', num2str(device_params.K_p_pll));
    set_param(device_name, 'K_i_pll', num2str(device_params.K_i_pll));
    
    % ACC PI gains for error in p.u. current and ctrl input in voltage,
    % normalised by Lf (Rf is ignored, assumed negligible
    set_param(device_name, 'K_p_acc', num2str(device_params.K_p_acc));
    set_param(device_name, 'K_i_acc', num2str(device_params.K_i_acc));

    %{
    params.Rf = 0;
    params.Lf = 0.2;
    params.P0 = 1.0;
    params.Q0 = 0.0;
    params.tau_rms = 0.02;
    params.K_p_acc = 35;
    params.K_i_acc = 800;
    params.K_p_pll = 60;
    params.K_i_pll = 1e3;
    %}
end
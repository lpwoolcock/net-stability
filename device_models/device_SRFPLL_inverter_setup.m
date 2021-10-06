function [] = device_SRFPLL_inverter_setup(base, device_name, device_params)
    % filter params in p.u.
    set_param(device_name, 'Rf', num2str(device_params.Rf));
    set_param(device_name, 'Lf', num2str(device_params.Lf));

    % current setpoint in p.u. and degrees
    set_param(device_name, 'Iref', num2str(device_params.Iref));
    set_param(device_name, 'phi', num2str(device_params.phi));
    
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
    params.Iref = 1.0;
    params.phi = 0;
    params.K_p_acc = 35;
    params.K_i_acc = 800;
    params.K_p_pll = 60;
    params.K_i_pll = 1e3;
    %}
end
function [] = device_PLLDVC_inverter_setup(base, device_name, device_params)
    % filter params in p.u.
    set_param(device_name, 'Rf', num2str(device_params.Rf));
    set_param(device_name, 'Lf', num2str(device_params.Lf));
    
    % PLL PI gains for error in p.u. voltage and state in radians
    set_param(device_name, 'K_p_pll', num2str(device_params.K_p_pll));
    set_param(device_name, 'K_i_pll', num2str(device_params.K_i_pll));
    
    % ACC PI gains for error in p.u. current and ctrl input in voltage,
    % normalised by Lf (Rf is ignored, assumed negligible
    set_param(device_name, 'K_p_acc', num2str(device_params.K_p_acc));
    set_param(device_name, 'K_i_acc', num2str(device_params.K_i_acc));

    % DVC PI gains for error in p.u. voltage and ctrl input in p.u. current
    % normalised by Lf (Rf is ignored, assumed negligible
    set_param(device_name, 'K_p_dvc', num2str(device_params.K_p_dvc));
    set_param(device_name, 'K_i_dvc', num2str(device_params.K_i_dvc));

    % power flow into DC bus in p.u.
    set_param(device_name, 'Psrc', num2str(device_params.Psrc));
    % reactive current setpoint in p.u.
    set_param(device_name, 'Iq', num2str(device_params.Iq));
    % DC bus capacitor in p.u.
    set_param(device_name, 'Cdc', num2str(device_params.Cdc));

    %{
    params.Rf = 0;
    params.Lf = 0.2;
    params.K_p_acc = 35;
    params.K_i_acc = 800;
    params.K_p_pll = 60;
    params.K_i_pll = 1e3;
    params.K_p_dvc = 13;
    params.K_i_dvc = 1e3;
    params.Psrc = 5;
    params.Iq = 0;
    params.Cdc = 50;
    %}
end
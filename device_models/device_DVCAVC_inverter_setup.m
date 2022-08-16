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
    set_param(device_name, 'K_p_dvc', num2str(device_params.K_p_dvc));
    set_param(device_name, 'K_i_dvc', num2str(device_params.K_i_dvc));

    % AVC PI gains for error in p.u. voltage and ctrl input in p.u. current
    set_param(device_name, 'K_p_avc', num2str(device_params.K_p_avc));
    set_param(device_name, 'K_i_avc', num2str(device_params.K_i_avc));

    % power flow into DC bus in p.u.
    set_param(device_name, 'Psrc', num2str(device_params.Psrc));
    % PCC voltage setpoint in p.u.
    set_param(device_name, 'Vref', num2str(device_params.Vref));
    % DC bus capacitor in p.u.
    set_param(device_name, 'Cdc', num2str(device_params.Cdc));
    % DC bus capacitor in p.u.
    set_param(device_name, 'K_droop', num2str(device_params.K_droop));

    %{
    params.Rf = 0;
    params.Lf = 0.2;
    params.K_p_acc = 35;
    params.K_i_acc = 800;
    params.K_p_pll = 60;
    params.K_i_pll = 1e3;
    params.K_p_dvc = 13;
    params.K_i_dvc = 1e3;
    params.K_p_avc = 0;
    params.K_i_avc = 1e3;
    params.Psrc = 5;
    params.Vref = 1.0;
    params.Cdc = 50;
    %}
end
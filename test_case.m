function nl_case = test_case()
    base = setup_base(100e6, 138e3, 50);
    
    % WTG model
    devices(1).type = 'device_PLLDVC_inverter';
    devices(1).bus = 2;
    devices(1).powerflow.type = 'PQ';
    devices(1).powerflow.P = 5;
    devices(1).powerflow.Q = 0;
    
    devices(1).params.Rf = 0;
    devices(1).params.Lf = 0.2;
    devices(1).params.K_p_acc = 35;
    devices(1).params.K_i_acc = 800;
    devices(1).params.K_p_pll = 60;
    devices(1).params.K_i_pll = 1e3;
    devices(1).params.K_p_dvc = 13;
    devices(1).params.K_i_dvc = 1e3;
    devices(1).params.Psrc = 5;
    devices(1).params.Iq = 0;
    devices(1).params.Cdc = 50;


    % statcom model
    devices(2).type = 'device_DVCAVC_inverter';
    devices(2).bus = 1;
    devices(2).powerflow.type = 'PV';
    devices(2).powerflow.P = 0;
    devices(2).powerflow.V = 1.0;

    devices(2).params.Rf = 0;
    devices(2).params.Lf = 0.2;
    devices(2).params.Cdc = 2 * 5 * 0.64; % 64MVA STATCOM
    devices(2).params.K_p_acc = 35;
    devices(2).params.K_i_acc = 800;
    devices(2).params.K_p_pll = 60;
    devices(2).params.K_i_pll = 1e3;
    devices(2).params.K_p_dvc = 13 * 0.64/5;
    devices(2).params.K_i_dvc = 1e3 * 0.64/5;
    devices(2).params.K_p_avc = 0;
    devices(2).params.K_i_avc = 1e3;
    devices(2).params.Psrc = 0;
    devices(2).params.Vref = 1.0;




    
    branches(1).type = 'branch_RL';
    branches(1).bus1 = 0; % slack bus/infinite grid
    branches(1).bus2 = 1;
    
    branches(1).params.R = 0.0174;
    branches(1).params.L = 0.0985;
    Z = branch_get_Z(branches(1), 1);
    branches(1).powerflow.R = real(Z);
    branches(1).powerflow.X = imag(Z);
    
    branches(2).type = 'branch_RL';
    branches(2).bus1 = 1;
    branches(2).bus2 = 2;
    
    branches(2).params.R = 0.00174;
    branches(2).params.L = 0.00985;
    Z = branch_get_Z(branches(2), 1);
    branches(2).powerflow.R = real(Z);
    branches(2).powerflow.X = imag(Z);
    
    branches(3).type = 'branch_Ctype';
    branches(3).bus1 = 1;
    branches(3).bus2 = -1; % gnd
    
    branches(3).params.C1 = 1.25;
    branches(3).params.C = 3.75;
    branches(3).params.L = 4/15;
    branches(3).params.R = 0.8;
    Z = branch_get_Z(branches(3), 1);
    branches(3).powerflow.R = real(Z);
    branches(3).powerflow.X = imag(Z);

    nl_case.base = base;
    nl_case.branches = branches;
    nl_case.devices = devices;
end
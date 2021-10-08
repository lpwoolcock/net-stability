base = setup_base(100e6, 138e3, 50);

devices.type = 'device_SRFPLL_inverter';
devices.bus = 2;
devices.powerflow.type = 'PQ';
devices.powerflow.P = 5;
devices.powerflow.Q = 0;

devices.params.Rf = 0;
devices.params.Lf = 0.2;
devices.params.Iref = 5.0; % should change with operating pt.
devices.params.phi = 0;
devices.params.K_p_acc = 35;
devices.params.K_i_acc = 800;
devices.params.K_p_pll = 60;
devices.params.K_i_pll = 1e3;


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

branches(3).params.C1 = 0.5;
branches(3).params.C = 1.5;
branches(3).params.L = 2/3;
branches(3).params.R = 2;
Z = branch_get_Z(branches(3), 1);
branches(3).powerflow.R = real(Z);
branches(3).powerflow.X = imag(Z);
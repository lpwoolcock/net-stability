function [mpc] = mpc_gen(base, Vg, branches, devices)
    mpc.baseMVA = base.S / 1e6;

    buses = [];

    % find all the branch bus numbers, exclude 0 (slack bus/inf grid) and -1
    % (gnd)
    for branch = branches
        if branch.bus1 > 0 && isempty(find(buses == branch.bus1, 1))
            buses = [buses; branch.bus1];
        end
        if branch.bus2 > 0 && isempty(find(buses == branch.bus2, 1))
            buses = [buses; branch.bus2];
        end
    end

    % we don't ennumerate buses of devices cause if they're floating,
    % that's an error anyway

    slack = max(buses) + 1;

    mpc.bus = zeros(length(buses)+1, 13);
    mpc.bus(:,1) = [buses;slack]; % bus numbers
    mpc.bus(1:end-1, 2) = 1; % buses are PQ by default, a PV device changes this property to PV
    mpc.bus(slack, 2) = 3;
    mpc.bus(:, 7) = 1; % area number. not used
    mpc.bus(:, 8) = 1; % voltage magnitude - only for slack bus
    mpc.bus(:, 10) = base.V / 1e3; % base V in kV
    mpc.bus(:, 11) = 1; % loss zone??? idk wht this is
    mpc.bus(:, 12) = 100; % max voltage
    mpc.bus(:, 13) = 0; % min voltage

    struck_branches = zeros(length(branches), 1);
    for k = 1:length(branches)
        branch = branches(k);

        if branch.bus1 == branch.bus2
            struck_branches(k) = true;
        elseif branch.bus1 == -1
            n = find(buses == branch.bus2, 1);
            Y = 1/(branch.powerflow.R + 1j*branch.powerflow.X);
            mpc.bus(n, 5) = mpc.bus(n,5) + mpc.baseMVA * real(Y);
            mpc.bus(n, 6) = mpc.bus(n,6) + mpc.baseMVA * imag(Y);
            struck_branches(k) = true;
        elseif branch.bus2 == -1 % TODO: clumsy way of dealing with this
            n = find(buses == branch.bus1, 1);
            Y = 1/(branch.powerflow.R + 1j*branch.powerflow.X);
            mpc.bus(n, 5) = mpc.bus(n,5) + mpc.baseMVA * real(Y);
            mpc.bus(n, 6) = mpc.bus(n,6) + mpc.baseMVA * imag(Y);
            struck_branches(k) = true;
        end
    end

    remaining_branches = branches(~struck_branches);
    mpc.branch = zeros(length(remaining_branches), 13);

    for k = 1:length(remaining_branches)
        branch = remaining_branches(k);

        if branch.bus1 == 0
            mpc.branch(k,1) = slack;
        else
            mpc.branch(k,1) = find(buses == branch.bus1);
        end

        if branch.bus2 == 0
            mpc.branch(k,2) = slack;
        else
            mpc.branch(k,2) = find(buses == branch.bus2);
        end

        mpc.branch(k,3) = branch.powerflow.R;
        mpc.branch(k,4) = branch.powerflow.X;
        % will we ever deal with charging susceptance?
        mpc.branch(k,11) = 1; % in service
        mpc.branch(k,12) = -360; % angle limits
        mpc.branch(k,13) = 360; % angle limits
    end

    mpc.gen = zeros(length(devices) + 1, 21);

    for k = 1:length(devices)
        device = devices(k);

        mpc.gen(k,1) = find(buses == device.bus, 1);
        mpc.gen(k,2) = device.powerflow.P * mpc.baseMVA;
        if strcmp(device.powerflow.type, 'PQ')
            mpc.gen(k,3) = device.powerflow.Q * mpc.baseMVA;
        elseif strcmp(device.powerflow.type, 'PV')
            mpc.gen(k,6) = device.powerflow.V;
            mpc.bus(mpc.gen(k,1), 2) = 2; % PV device forces its bus to PV type
        else
            error(strcat('Device no. ', num2str(k), ' has invalid powerflow type.'));
        end
        mpc.gen(k,4) = 1e6; % Q limits, i don't know if you can just set these to 0?
        mpc.gen(k,5) = -1e6;
        mpc.gen(k,8) = 1; % in service
        mpc.gen(k,9) = 1e6; % P limits
        mpc.gen(k,10) = -1e6;
        % a bunch of other stuff that gets set to zero?
    end

    % slack bus gen
    mpc.gen(end,1) = slack;
    mpc.gen(end,4) = 1e6; % Q limits, i don't know if you can just set these to 0?
    mpc.gen(end,5) = -1e6;
    mpc.gen(end,6) = Vg;
    mpc.gen(end,8) = 1; % in service
    mpc.gen(end,9) = 1e6; % P limits
    mpc.gen(end,10) = -1e6;
end


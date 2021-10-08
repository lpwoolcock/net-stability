function [op_pt] = powerflow(nl_case)
    mpc = mpc_gen(nl_case.base, nl_case.branches, nl_case.devices);
    results = runpf(mpc, mpoption('out.all', 0, 'verbose', 0));
    op_pt.buses = results.bus(1:end-1, 1);
    op_pt.V = results.bus(1:end-1, 8);
    op_pt.theta = results.bus(1:end-1, 9);
end


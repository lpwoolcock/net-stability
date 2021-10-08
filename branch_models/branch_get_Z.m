function [Z] = branch_get_Z(branch, omega)
    % Calculate branch impedance in stationary frame at omega in per unit
    
    syms s

    switch branch.type
        case 'branch_RL'
            Zs = branch.params.R + s * branch.params.L;
        case 'branch_RLC'
            Zs = branch.params.R + s * branch.params.L + 1 / (s * branch.params.C);
        case 'branch_Ctype'
            R = branch.params.R;
            C1 = branch.params.C1;
            C = branch.params.C;
            L = branch.params.L;
            Zs =  (R*s^3 + s^2/C1 + (R/L) * (1/C+1/C1) * s + 1/(L*C*C1)) / (s^3 + R/L * s^2 + 1/(L*C) * s);
        otherwise
            error('Invalid branch type')
    end
    
    if strcmp(omega, 's')
        Z = Zs;
    else
        Z = double(subs(Zs, s, 1j*omega));
    end
end


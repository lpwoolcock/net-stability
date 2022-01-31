function [Gdq] = tf_s2dq(Gs, omega_grid, omega_s)
    % Gs is stationary frame balanced impedance in terms of 's'
    % omega_grid is dq frequency grid
    % omega_s is dq frame frequency

    syms s 

    Gpn = zeros(2,2,length(omega_grid));
    Gpn(1,1,:) = double(subs(Gs, s, 1j * (omega_grid + omega_s)));
    Gpn(2,2,:) = double(subs(Gs, s, 1j * (omega_grid - omega_s)));

    Az = (1/sqrt(2)) * [1 1j; 1 -1j];
    Gdq = pagemtimes(Az', pagemtimes(Gpn, Az));
end


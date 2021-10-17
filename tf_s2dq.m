function [ZY_dq] = tf_s2dq(tf_s, omega_grid, omega_s)
    % takes symbolic expr in terms of 's', 
    
    syms s J
    
    tf_dq = subs(tf_s, s, s + J*omega_s);
    
    [tf_dq_num, tf_dq_den] = numden(tf_dq);
    
    tf_dq_num_coeffs = coeffs(tf_dq_num, J);
    tf_dq_den_coeffs = coeffs(tf_dq_den, J);

    tf_dq_num = 0;
    for k=1:length(tf_dq_num_coeffs)
        tf_dq_num = tf_dq_num + tf_dq_num_coeffs(k)*[0 -1; 1 0]^(k-1);
    end
    
    tf_dq_den = 0;
    for k=1:length(tf_dq_den_coeffs)
        tf_dq_den = tf_dq_den + tf_dq_den_coeffs(k)*[0 -1; 1 0]^(k-1);
    end
    
    tf_dq_sym = tf_dq_num / tf_dq_den;

    ZY_dq = zeros(2, 2, length(omega_grid));
    
    for k = 1:length(omega_grid)
        ZY_dq(:,:,k) = subs(tf_dq_sym, s, 1j * omega_grid(k));
    end
end


function [A_acc, B_acc, B_acc_pll,  B_acc_pq,...
    C_acc, D_acc, D_acc_pll, D_acc_pq] = ss_acc(k_p_acc, k_i_acc, K_d, v_c_bar, v_b_bar, i_c_bar)
    
    I2 = eye(2);
    J = [0 -1;
         1  0];
    
    x_acc_bar = v_c_bar - v_b_bar - K_d * i_c_bar;

    A_acc = zeros(2);
    B_acc = [zeros(2), -k_i_acc * I2];
    B_acc_pll = [zeros(2,1) J*x_acc_bar];
    B_acc_pq = k_i_acc * I2;
    C_acc = I2;
    D_acc = [I2, K_d-k_p_acc*I2];
    D_acc_pll = zeros(2);
    D_acc_pq = k_p_acc * I2;
end


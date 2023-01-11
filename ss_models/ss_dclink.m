function [Adc, Bdcv, Bdci] = ss_dclink(Cdc, vdc_bar, vc_prime_bar, ic_prime_bar)
    %Adc = 0;
    Adc = vc_prime_bar.' * ic_prime_bar / (Cdc*vdc_bar^2);
    Bdcv = -ic_prime_bar.' / (Cdc*vdc_bar);
    Bdci = -vc_prime_bar.' / (Cdc*vdc_bar);
end


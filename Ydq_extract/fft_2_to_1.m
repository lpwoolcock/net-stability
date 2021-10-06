function [fft_1] = fft_2_to_1(fft_2)
    N = length(fft_2);

    if mod(N,2) == 0
        K = N/2;
    else
        K = (N-1)/2 + 1;
    end

    fft_1 = fft_2(1:K);
    fft_1(2:end) = 2 * fft_1(2:end);
end


function [xCx, x] = numrange(C, n)
    
    m = length(C);
    x = complex(randn(m, n), randn(m, n));
    x = x ./ vecnorm(x);

    xCx = zeros(1, n);

    for k = 1:n
        xCx(k) = x(:,k)' * C * x(:,k);
    end
end


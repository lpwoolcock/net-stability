function [eigen] = pageeig(A)
    N = size(A,3);
    eigen = zeros(size(A,1), 1, N);

    for k=1:N
        eigen(:,:,k) = eig(A(:,:,k));
    end
end


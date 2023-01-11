function [T, Lambda] = pageeig(A)
    % returns [T(:,:,k), Lambda(:,:,k)] = eig(A(:,:,k))
    % with the additional stipulation that the ordering is such that the
    % eigenvectors and values change continuously

    N = size(A,3);
    T = zeros(size(A));
    Lambda = zeros(size(A));

    n = size(A, 1);
    p = perms(1:n);
    P = zeros(n, n, size(p, 1));
    for k = 1:size(p, 1)
        P(sub2ind(size(P), p(1,:), p(k, :), repmat(k, [1 n]))) = 1;
    end

    [T(:,:,1), Lambda(:,:,1)] = eig(A(:,:,1));

    for k=2:N
        [Tk, Lambda_k] = eig(A(:, :, k));
        Tp = pagemtimes(Tk, P);

        [~, i] = min(squeeze(pagenorm(Tp-T(:,:,k-1), "fro")));

        T(:,:,k) = Tp(:,:,i);
        Lambda(:,:,k) = P(:,:,i)' * Lambda_k * P(:,:,i);
    end
end


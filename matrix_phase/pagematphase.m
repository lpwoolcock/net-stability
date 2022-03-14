function [phi] = pagematphase(G)
    N = size(G,3);
    n = size(G,1);

    phi = zeros(n, N);

    for k=1:N
        phi(:,k) = matphase(G(:,:,k));
    end
end


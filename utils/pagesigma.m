function [sigma] = pagesigma(C)
    [~, S, ~] = pagesvd(C);
    
    sigma = zeros(size(C, 1), size(C,3));

    for k = 1:size(S, 3)
        sigma(:,k) = diag(S(:,:,k));
    end
end


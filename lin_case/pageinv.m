function ZY = pageinv(YZ)
    N = size(YZ,3);
    ZY = zeros(size(YZ));

    for n = 1:N
        ZY(:,:,n) = inv(YZ(:,:,n));
    end
end


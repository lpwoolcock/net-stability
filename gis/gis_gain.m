function [mu] = gis_gain(G)
    mu = mussv(G, [1 0; 1 0]);
    mu = squeeze(mu(1, 1, :));
end


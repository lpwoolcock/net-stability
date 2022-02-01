function phi = matphase(C)
    z = accretise(C);
    if isnan(z)
        phi = nan;
    else
        phi = sort(wrapToPi(accrphase(z*C) - angle(z)), 'descend');
    end
end


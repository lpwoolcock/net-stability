function phi = matphase(C)
    z = accretise(C);
    if isnan(z)
        phi = nan;
    else
        phi = wrapToPi(accrphase(z*C) - angle(z));
    end
end


function phi = accrphase(C)
    % computes canonical angles phi of a strictly accretive matrix C
    % (hermitian part strictly positive definite)

    phi = 1/2 * angle(eig(C/(C')));
end
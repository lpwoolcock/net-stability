function z = accretise(C)
    % find complex scalar z s.t. zC is strictly accretive (positive
    % definite Hermitian part)
    % returns NaN if C is not sectorial

    N = length(C);

    A = 1/2 * (C + C');
    Ar = [real(A) imag(A); -imag(A) real(A)];
    B = 1/2j * (C - C');
    Br = [real(B) imag(B); -imag(B) real(B)];

    setlmis([]);
    x = lmivar(1, [1 0]);
    y = lmivar(1, [1 0]);

    % I < 2xA - 2yB
    lmiterm([-1 1 1 x], 1, 2*Ar);
    lmiterm([-1 1 1 y], 1, -2*Br);
    lmiterm([1 1 1 0], eye(2*N));

    lmi = getlmis;

    options = [0 0 0 0 1];
    [tmin, xy] = feasp(lmi, options);
    
    if tmin < 0
        xval = dec2mat(lmi, xy, x);
        yval = dec2mat(lmi, xy, y);
        z = xval + 1j * yval;
        z = z / abs(z);
    else
        z = nan;
    end
end


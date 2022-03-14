function bode_matrix(omega, G)

    sigma = pagesigma(G);
    phi = pagematphase(G);

    figure
    tiledlayout(2,1);

    nexttile
    semilogx(omega, 20*log10(sigma));
    nexttile
    semilogx(omega, phi*180/pi);
end
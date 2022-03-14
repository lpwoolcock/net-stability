function bode_gnc(omega, G)

    lambda = pageeig(G);

    figure
    tiledlayout(2,1);

    nexttile
    semilogx(omega, 20*log10(squeeze(abs(lambda))));
    nexttile
    semilogx(omega, squeeze(unwrap(angle(lambda)))*180/pi);
end
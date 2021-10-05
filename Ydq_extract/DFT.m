function [Id_phasor, Iq_phasor] = DFT(Id, Iq, t_start, f_p)
    k_start = find(Id.Time>=t_start, 1);
    
    t = Id.Time(k_start:end);
    id = Id.Data(k_start:end);
    iq = Iq.Data(k_start:end);
    
    cos_k = cos(2*pi*f_p*t);
    sin_k = sin(2*pi*f_p*t);
    
    Id_phasor = 2*mean(cos_k .* id) - 2j*mean(sin_k .* id);
    Iq_phasor = 2*mean(cos_k .* iq) - 2j*mean(sin_k .* iq);
end


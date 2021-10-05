function [base] = setup_base(Sb, Vb, fb)
    base.S = Sb;
    base.V = Vb;
    base.I = Sb/Vb;
    base.Z = Vb^2/Sb;
    base.Y = 1/base.Z;
    
    base.f = fb;
    base.omega = 2 * pi * fb;
    
    base.L = base.Z/base.omega;
    base.C = 1/(base.omega*base.Z);
end


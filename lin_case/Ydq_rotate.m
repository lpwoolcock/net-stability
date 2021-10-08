function [Ydq_rot] = Ydq_rotate(Ydq, delta)

    rotpos = [cosd(delta), -sind(delta); sind(delta), cosd(delta)];
    rotneg = [cosd(delta), sind(delta); -sind(delta), cosd(delta)];
    
    Ydq_rot = rotpos * Ydq * rotneg;

end
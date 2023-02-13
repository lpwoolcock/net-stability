function [] = sector_plot(x, Phi, colour)
    % f is (m,1) real matrix
    % Phi is (?,m) real matrix
    m = length(x);

    phi = Phi(:,1);
    sector_x = x(1);
    if isnan(phi)
        type = 1;
        sector1 = [-pi; pi];
    else
        beta = max(phi);
        alpha = min(phi);
        if beta - alpha < pi
            type = 1;
            sector1 = [alpha; beta];
        else
            type = 2;
            sector1 = [beta; pi];
            sector2 = [-pi; alpha];
        end
    end
    

    polys = {};

    for k = 2:m
        phi = Phi(:,k);
        if isnan(phi)
            if type == 1
                sector1 = [sector1 [-pi;pi]];
                sector_x(end+1) = x(k);
            else
                polys{end+1} = polyshape([sector_x flip(sector_x)], [sector1(1,:) flip(sector1(2,:))]);
                polys{end+1} = polyshape([sector_x flip(sector_x)], [sector2(1,:) flip(sector2(2,:))]);

                type = 1;
                sector1 = [-pi; pi];
                sector_x = x(k);
            end
        else
            if wrapToPi(phi(1) - phi(2)) > 0
                alpha = phi(1);
                beta = phi(2);
            else
                alpha = phi(2);
                beta = phi(1);
            end

            if type == 1 && alpha > beta
                sector1 = [sector1 [alpha;beta]];
                sector_x(end+1) = x(k);
            elseif type == 1 && beta >= alpha
                polys{end+1} = polyshape([sector_x flip(sector_x)], [sector1(1,:) flip(sector1(2,:))]);
                type = 2;
                sector1 = [beta; pi];
                sector2 = [-pi; alpha];
                sector_x = x(k);
            elseif type == 2 && alpha > beta
                polys{end+1} = polyshape([sector_x flip(sector_x)], [sector1(1,:) flip(sector1(2,:))]);
                polys{end+1} = polyshape([sector_x flip(sector_x)], [sector2(1,:) flip(sector2(2,:))]);
                type = 1;
                sector1 = [alpha; beta];
                sector_x = x(k);
            else
                sector1 = [sector1 [beta; pi]];
                sector2 = [sector2 [-pi; alpha]];
                sector_x(end+1) = x(k);
            end
        end
        
    end

    if type == 1
        polys{end+1} = polyshape([sector_x flip(sector_x)], [sector1(1,:) flip(sector1(2,:))]);
    else
        polys{end+1} = polyshape([sector_x flip(sector_x)], [sector1(1,:) flip(sector1(2,:))],...
            'KeepCollinearPoints', true);
        polys{end+1} = polyshape([sector_x flip(sector_x)], [sector2(1,:) flip(sector2(2,:))],...
            'KeepCollinearPoints', true);
    end

    for k=1:length(polys)
        plot(polys{k}, 'FaceColor', colour);
        hold on;
    end
end


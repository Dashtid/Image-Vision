function [linepar, acc] = houghline(curves, magnitude, ...
nrho, ntheta, threshold, nlines, ~)

    % Creating Accumulator
    acc = zeros(nrho, ntheta);
    
    % Setting the coordinates
    theta_v = linspace(-pi/2,pi/2,ntheta);
    Dist = sqrt(size(magnitude,1)^2 + size(magnitude,2)^2);
    rho_v = linspace(-Dist, Dist, nrho);
    
    size_input = size(curves, 2);
    trypointer = 1;
    
    while (trypointer <= size_input)
    polylength = curves(2, trypointer);
    trypointer = trypointer + 1;
    
        for polyidx = 1:polylength
        x = curves(2, trypointer);
        y = curves(1, trypointer);
        trypointer = trypointer + 1;
        m = magnitude(round(x), round(y));
        
        if m < threshold
            continue;
        end
        
            % Thetha
            for theta = 1:ntheta
                
                % Rho
                rho = x*cos(theta_v(theta))+...
                    y*sin(theta_v(theta));
            
                % Index for rho
                idx_rho = find(rho_v<rho,1,'last');
                
                % Q 10 - Voting
                acc(idx_rho, theta) = acc(idx_rho, theta) + log(m);
                %acc(idx_rho, theta) = acc(idx_rho, theta)+ 1;              
                
            end
        end
    end
    
    % Local maximum from acc
    [pos, value] = locmax8(acc);
    [~, indexvector] = sort(value);
    max = size(value, 1);

    % Line according to acc
    linepar = zeros(2, nlines);
    
    for idx = 1:nlines
    rhoidxacc = pos(indexvector(max - idx + 1), 1);
    thetaidxacc = pos(indexvector(max - idx + 1), 2);
    linepar(:,idx) = [rho_v(rhoidxacc);theta_v(thetaidxacc)];
    end
    
    %figure();
    showgrey(acc);
    title('Acumulator');   
    
end
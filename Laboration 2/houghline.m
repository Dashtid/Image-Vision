function [linepar, acc] = houghline(curves, magnitude, nrho, ntheta, threshold, nlines)

  % Check edge one time, i.e. x and y are rounded 
    accChecker = zeros(size(magnitude)); 

    % Creating accumulator space
    acc = zeros(nrho, ntheta);

    % Coordinate system setup
    rhoBoundaries = sqrt(size(magnitude, 1)^2 + size(magnitude, 2)^2);
    theta = linspace(-pi/2, pi/2, ntheta);
    rho = linspace(-rhoBoundaries, rhoBoundaries, nrho);

    % Loop over all the input curves (cf. pixelplotcurves)
    insize = size(curves, 2);
    trypointer = 1;

    % Defining a monotonicaaly increasing accumulator increment function
    f = monoFunction();
    
    % Every point on every curve
    while (trypointer <= insize) 
        
        polylength = curves(2, trypointer);
        trypointer = trypointer + 1;
    
        for polyidx = 1:polylength
            
            x = curves(2, trypointer);
            y = curves(1, trypointer);
            M = magnitude(round(x),round(y));
            
            if (M >= threshold && accChecker(round(x),round(y)) == 0)
                accChecker(round(x),round(y)) = 1;
                % Loop through theta
                for i = 1:insize(theta,2)
                    
                    % Rho of all theta 
                    rho = x * cos(theta(i)) + y * sin(theta(i));
                
                    % Indexing accumulator
                    [~, j] = min(abs(rho - rho));

                    % Update the accumulator                   
                    acc(j, i) = acc(j, i) + f(abs(M)); 
                end                  
            end
            trypointer = trypointer + 1;
        end       
    end
    
    print('kuken')
    
    % Extract local maxima from the accumulator
    [pos, value] = locmax8(acc); 
    [~, indexvector] = sort(value);
    nmaxima = size(value, 1);

    % Delimit the number of responses if necessary
    linepar = zeros(2,nlines);
    for idx = 1:nlines
         rhoidxacc = pos(indexvector(nmaxima - idx + 1), 1);
         thetaidxacc = pos(indexvector(nmaxima - idx + 1), 2);
         linepar(:,idx) = [rho(rhoidxacc);theta(thetaidxacc)]; 
    end
end

function f = monoFunction()
     f = @(n) log(n+1);
end
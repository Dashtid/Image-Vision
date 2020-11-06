function outcurves = houghedgeline(pic, scale,... 
    gradmagnthreshold, nrho, ntheta, nlines, verbose)
    
    % Using the Lvtilde function
    Lvtemp = Lv(discgaussfft(pic, scale));
    
    % Using the extractedge function
    curves = extractedge(pic, scale, gradmagnthreshold, 'same');
    
    % Using the houghline function
    [linepar, acc] = houghline(curves, Lvtemp, nrho, ntheta,...
        gradmagnthreshold, nlines);
   
    outcurves = houghToLine(Lvtemp, linepar);
    
   if verbose ~= 0
        figure('Name','Accumulator Space')
        showgrey(acc)
        title("Accumulator space")
   end 
    
   if (verbose == 2)
       fprintf("Theta first row, and rho on second row\n")
       disp(linepar) 
       fprintf("\nx0 x1 x2 x3\y0 y1 y2 y3\n")
       disp(outcurves) 
   end
   
end

function outcurves = houghToLine(magnitudePic, linepar) 

    nlines = size(linepar, 2);
    outcurves = zeros(2,4*nlines);
    D = sqrt(size(magnitudePic,1)^2 + size(magnitudePic,2)^2);
    A = [-D, 0, D];
    for q = 1:nlines
        rho = linepar(1,q);
        theta = linepar(2,q);
        X = sin(theta)*A + rho*cos(theta);
        Y = -cos(theta)*A + rho*sin(theta);
        outcurves(:, 1+(q-1)*(nlines+1):1+(q-1)*(nlines+1)+3) = [[0;3], [Y;X]];
    end    
end


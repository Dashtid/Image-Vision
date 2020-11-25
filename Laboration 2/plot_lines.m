function plot_lines(img, linepar, verbose)

max = sqrt(size(img, 1)^2 + size(img, 2)^2);
nlines = size(linepar, 2);
curve = zeros(2, 4 * nlines);

    for idx = 1 : nlines
    rho = linepar(1, idx);
    theta = linepar(2, idx);

    x0 = 0;
    y0 = (-cos(theta)/sin(theta)) * x0 + (rho/sin(theta));
    dx = max^2;
    dy = (-cos(theta)/sin(theta)) * dx + (rho/sin(theta));
    
    curve(1, 4*(idx-1) + 1) = 0; % level, not significant
    curve(2, 4*(idx-1) + 1) = 3; % number of points in the curve
   
    curve(2, 4*(idx-1) + 2) = x0 - dx;
    curve(1, 4*(idx-1) + 2) = y0 - dy;
    
    curve(2, 4*(idx-1) + 3) = x0;
    curve(1, 4*(idx-1) + 3) = y0;
    
    curve(2, 4*(idx-1) + 4) = x0 + dx;
    curve(1, 4*(idx-1) + 4) = y0 + dy;
    end
    
    if(verbose == 1)
       figure();
       overlaycurves(img, curve);
       title('Image & Lines');
       axis([1 size(img, 2) 1 size(img, 1)]);
        
    else
    figure();
    overlaycurves(img, curve);
    axis([1 size(img, 2) 1 size(img, 1)]);
    
    end
end
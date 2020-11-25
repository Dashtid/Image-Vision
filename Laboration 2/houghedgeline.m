function houghedgeline(img, scale, gradmagnthreshold, ...
nrho, ntheta, nlines, verbose)

    L_v = Lv(discgaussfft(img, scale));
    
    curves = extractedge(img, scale, gradmagnthreshold, 'same');
    
    [linepar, acc] = houghline(curves, L_v, nrho, ntheta,...
        gradmagnthreshold, nlines, verbose);

    plot_lines(img, linepar, verbose);   
    
end

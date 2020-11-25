function edgecurves = extractedge(inpic, scale, threshold, shape)

% Smoothing the image
smoothened_image = discgaussfft(inpic, scale);

% First order derivative
Lv_start = Lv(smoothened_image, shape);

% Second order derivative zero crossings
Lvv = Lvvtilde(smoothened_image, shape);

% Extra condition that is to be applied (mask)
Lvvv = Lvvvtilde(smoothened_image, shape);

% Masks
Lv_mask = (Lv_start > threshold) - 0.5;
Lvvv_mask = (Lvvv < 0) - 0.5;


% Computing zero crossings with the condition
edgecurves = zerocrosscurves(Lvv, Lvvv_mask);

% Points where the mask in non-negative
edgecurves = thresholdcurves(edgecurves, Lv_mask);

end
function edgecurves = extractedge(inpic, scale, threshold, shape)

% Smoothing the image
smoothened_image = discgaussfft(inpic, scale);

% Second order derivative zero crossings
zero_image = Lvvtilde(smoothened_image, shape);

% Extra condition that is to be applied (mask)
Lvvv = Lvvvtilde(smoothened_image, shape);

% Computing zero crossings with the condition
edgecurves = zerocrosscurves(zero_image, Lvvv);

% Condition to be applied for the thresholding (mask)
Lv_mask = (Lv(smoothened_image, shape) > threshold) - 0.5;

% Points where the mask in non-negative
edgecurves = thresholdcurves(edgecurves, Lv_mask);

end
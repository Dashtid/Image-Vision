function edgecurves = extractedge(inpic, scale, threshold, shape)
% EXTRACTEDGE Extracts edge curves from an image using differential geometry descriptors.
%   edgecurves = extractedge(inpic, scale, threshold, shape)
%   - inpic: input image
%   - scale: standard deviation for Gaussian smoothing
%   - threshold: threshold for gradient magnitude
%   - shape: convolution shape ('same', etc.)

    % Smooth the image
    smoothened_image = discgaussfft(inpic, scale);

    % First order derivative (gradient magnitude squared)
    Lv_start = Lv(smoothened_image, shape);

    % Second and third order derivatives
    Lvv = Lvvtilde(smoothened_image, shape);
    Lvvv = Lvvvtilde(smoothened_image, shape);

    % Masks for thresholding
    Lv_mask = (Lv_start > threshold) - 0.5;
    Lvvv_mask = (Lvvv < 0) - 0.5;

    % Zero crossings with condition
    edgecurves = zerocrosscurves(Lvv, Lvvv_mask);

    % Apply gradient magnitude mask
    edgecurves = thresholdcurves(edgecurves, Lv_mask);
end
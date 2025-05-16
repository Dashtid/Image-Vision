% plot_utils.m
% Utility plotting functions for edge detection and Hough transform

function plot_lines(img, linepar, verbose)
% PLOT_LINES Overlay detected lines on an image.
%   plot_lines(img, linepar, verbose)
%   - img: image to plot on
%   - linepar: [rho; theta] pairs (2 x nlines)
%   - verbose: if true, show figure title

    maxlen = sqrt(size(img, 1)^2 + size(img, 2)^2);
    nlines = size(linepar, 2);
    curve = zeros(2, 4 * nlines);

    for idx = 1:nlines
        rho = linepar(1, idx);
        theta = linepar(2, idx);

        x0 = 0;
        y0 = (-cos(theta)/sin(theta)) * x0 + (rho/sin(theta));
        dx = maxlen^2;
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

    figure;
    overlaycurves(img, curve);
    axis([1 size(img, 2) 1 size(img, 1)]);
    if verbose
        title('Image & Lines');
    end
end

function plotFunction(figureNr, image, scale, type, imageTitle, plotTitle)
% PLOTFUNCTION Plot differential geometry descriptors at multiple scales.
%   plotFunction(figureNr, image, scale, type, imageTitle, plotTitle)
%   - figureNr: figure number
%   - image: input image
%   - scale: vector of scales
%   - type: 0 = Lvv=0, 1 = Lvvv<0, 2 = Lvv=0 & Lvvv<0
%   - imageTitle: title for original image
%   - plotTitle: overall figure title

    figure(figureNr)
    for i = 1:6
        subplot(2, 3, i)
        if (i > 1)
            img_smooth = discgaussfft(image, scale(i - 1));
            if (type == 0)
                contour(Lvvtilde(img_smooth, 'same'), [0, 0])
            elseif (type == 1)
                showgrey(Lvvvtilde(img_smooth, 'same') < 0);
            else
                contour(Lvvtilde(img_smooth, 'same') + ...
                    ~(Lvvvtilde(img_smooth, 'same') < 0), [0, 0]);
            end
            axis('image')
            axis('ij')
            title("Scale = " + scale(i - 1));
        else
            showgrey(image)
            title(imageTitle)
        end
    end
    sgtitle(plotTitle)
end

function plotThresh(figureNr, image, thresholds, sigma, imageTitle)
% PLOTTHRESH Plot thresholded gradient magnitudes for different thresholds.
%   plotThresh(figureNr, image, thresholds, sigma, imageTitle)
%   - figureNr: figure number
%   - image: input image
%   - thresholds: vector of thresholds
%   - sigma: Gaussian smoothing parameter
%   - imageTitle: title for the image

    figure(figureNr)
    for i = 1:length(thresholds)
        subplot(1, length(thresholds), i);
        img_smooth = discgaussfft(image, sigma);
        showgrey(Lv(img_smooth, 'same') > thresholds(i));
        title([imageTitle, ', threshold=', num2str(thresholds(i)), ', sigma=', num2str(sigma)]);
    end
    sgtitle(['Thresholded gradient magnitude: ', imageTitle]);
end
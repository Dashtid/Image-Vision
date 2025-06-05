% Demonstration of various image segmentation algorithms and their results

%% K-MEANS ALGORITHM

% -------------------- Parameters -------------------- %
K = 8;              % Number of clusters
L = 15;             % Number of iterations
seed = 1337;        % Seed for reproducibility
scale_factor = 0.6; % Down-scaling factor for the image
image_sigma = 1.0;  % Gaussian blur sigma
thresh = 0.02;      % Threshold for stopping segmentation
% ---------------------------------------------------- %

% Load and preprocess image
Im = imread('orange.jpg');
I_resized = imresize(Im, scale_factor);
I_temp = I_resized;

% Apply Gaussian filtering
d = 2 * ceil(image_sigma * 2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I_input = imfilter(I_resized, h);

% Perform k-means segmentation
[Image_segmented, centers, counter] = kmeans_segm(I_input, K, L, seed, thresh);
I_segmented = mean_segments(I_temp, Image_segmented);
I_overlay = overlay_bounds(I_temp, Image_segmented);

% Plot results
figure
subplot(1, 3, 1)
imshow(Im);
title('Original image')

subplot(1, 3, 2)
imshow(I_segmented);
title('Segmented image');

subplot(1, 3, 3);
imshow(I_overlay);
title('Segmentation overlayed on the original image')

%% MEAN-SHIFT ALGORITHM

% Clean up workspace
clear; close all;

% -------------------- Parameters -------------------- %
spatial_bandwidth = 25.0;  % Spatial bandwidth for mean-shift
colour_bandwidth = 6.0;    % Colour bandwidth for mean-shift
num_iterations = 45;       % Number of mean-shift iterations
image_sigma = 1.0;         % Gaussian blur sigma
scale_factor = 0.6;        % Down-scaling factor
% ---------------------------------------------------- %

% Load and preprocess image
Im = imread('orange.jpg');
I_resized = imresize(Im, scale_factor);
I_temp = I_resized;

% Apply Gaussian filtering
d = 2 * ceil(image_sigma * 2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I_input = imfilter(I_resized, h);

% Perform mean-shift segmentation
Image_segmented = mean_shift_segm(Im, spatial_bandwidth, colour_bandwidth, num_iterations);
Im_segmented = mean_segments(I_temp, Image_segmented);
Im_overlay = overlay_bounds(I_temp, Image_segmented);

% Plot results
figure
subplot(1,2,1); 
imshow(Im_segmented); 
title('The segmented image');

subplot(1,2,2); 
imshow(Im_overlay);
title('Overlay')

%% NORMALIZED CUT ALGORITHM

% Clean up workspace
clear; close all;

% -------------------- Parameters -------------------- %
colour_bandwidth = 17.0;   % Colour bandwidth for similarity
radius = 12;               % Maximum neighbourhood distance
ncuts_thresh = 0.4;        % Normalized cut threshold
min_area = 15;             % Minimum area of segment
max_depth = 15;            % Maximum splitting depth
image_sigma = 1.5;         % Gaussian blur sigma
scale_factor = 0.6;        % Down-scaling factor
% ---------------------------------------------------- %

% Load and preprocess image
Im = imread('tiger2.jpg');
Im = imresize(Im, scale_factor);
Iback = Im;

% Apply Gaussian filtering
d = 2 * ceil(image_sigma * 2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
Im = imfilter(Im, h);

% Perform normalized cuts segmentation
Image_segmented = norm_cuts_segm(Im, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
Im_segmented = mean_segments(Iback, Image_segmented);
Im_overlay = overlay_bounds(Iback, Image_segmented);

% Plot results
figure
subplot(1, 2, 1);
imshow(Im_segmented); 
title('Resulting segmentation');

subplot(1, 2, 2); 
imshow(Im_overlay); 
title('Overlay');

%% GRAPH CUT ALGORITHM

% Clean up workspace
clear; close all;

% -------------------- Parameters -------------------- %
K = 15;                      % Number of Gaussian components
alpha = 16.0;                % Maximum edge cost
sigma = 8.0;                 % Edge cost decay
scale_factor = 0.6;          % Down-scaling factor
% ---------------------------------------------------- %

% Load and preprocess image
Im = imread('tiger1.jpg');
I_resized = imresize(Im, scale_factor);
I_temp = I_resized;

% Define and scale foreground rectangle [x1, y1, x2, y2]
foreground = [85, 115, 575, 305];  
foreground_scaled = int16(foreground * scale_factor); 

% Perform graph cut segmentation
[Image_segmented, prior] = graphcut_segm(I_resized, foreground_scaled, K, alpha, sigma);
Im_segmented = mean_segm(I_temp, Image_segmented);
Im_overlay = overlay_bounds(I_temp, Image_segmented);

% Plot results
figure
subplot(1, 3, 1);
imshow(Im_segmented); 
title('Resulting segmentation');

subplot(1, 3, 2);
imshow(Im_overlay); 
title('Overlay');

subplot(1, 3, 3);
imshow(prior); 
title('Prior foreground probabilities');
%% Answer script for Lab 3
% Author: David Dashti
% Date: 2021-01-21

%% K-MEANS ALGORITHM

% -------------------- Parameters -------------------- %
K = 8;              % Number of clusters
L = 15;              % Number of iterations
seed = 1337;         % Seed
scale_factor = 0.6;  % Factor for down-scale operation
image_sigma = 1.0;   % Blurring factor
thresh = 0.02;       % Threshold to stop segmentation
% ---------------------------------------------------- %

% Loading in the image and prepping it
Im = imread('orange.jpg');
I_resized = imresize(Im, scale_factor);
I_temp = I_resized;

% Performing filtering operations
d = 2 * ceil(image_sigma * 2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I_input = imfilter(I_resized, h);

% Performing segementation
[Image_segmented, centers, counter] = kmeans_segm(I_input, K, L, seed, thresh);
I_segmented = mean_segments(I_temp, Image_segmented);
I_resized = overlay_bounds(I_temp, Image_segmented);

% ------- Plotting ------- %
figure
subplot(1, 3, 1)
imshow(Im);
title('Original image')

subplot(1, 3, 2)
imshow(I_segmented);
title('Segmented image');

subplot(1, 3, 3);
imshow(I_resized);
title('Segmentation overlayed on the original image')

%% MEAN-SHIFT ALGORITHM

% Cleaning up
clear; close all;

% -------------------- Parameters -------------------- %
spatial_bandwidth = 25.0;  % Spatial bandwidth
colour_bandwidth = 6.0;    % Colour bandwidth
num_iterations = 45;       % Number of iterations
image_sigma = 1.0;         % Blurring factor
scale_factor = 0.6;        % Factor for down-scale operation
% ---------------------------------------------------- %

% Loading in the image and prepping it
Im = imread('orange.jpg');
I_resized = imresize(Im, scale_factor);
I_temp = I_resized;

% Performing filtering operations
d = 2 * ceil(image_sigma * 2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I_input = imfilter(I_resized, h);

% Performing segementation
Image_segmented = mean_shift_segm(Im, spatial_bandwidth, colour_bandwidth, num_iterations);
Im_segmented = mean_segments(I_temp, Image_segmented);
Im_overlay = overlay_bounds(I_temp, Image_segmented);

% ------- Plotting ------- %
figure
subplot(1,2,1); 
imshow(Im_segmented); 
title('The segmented image');

subplot(1,2,2); 
imshow(Im_overlay);
title('Overlay')

%% NORMALIZED CUT ALGORITHM

% Cleaning up
clear; close all;

% -------------------- Parameters -------------------- %
colour_bandwidth = 17.0;   % color bandwidth
radius = 12;               % maximum neighbourhood distance
ncuts_thresh = 0.4;        % cutting threshold
min_area = 15;             % minimum area of segment
max_depth = 15;            % maximum splitting depth
image_sigma = 1.5;         % Blurring factor
scale_factor = 0.6;        % Factor for down-scale operation
% ---------------------------------------------------- %

% Loading in the image and prepping it
Im = imread('tiger2.jpg');
Im = imresize(Im, scale_factor);
Iback = Im;

% Performing filtering operations
d = 2 * ceil(image_sigma * 2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
Im = imfilter(Im, h);

% Performing the segmentation and using a custom mean algorithm
Image_segmented = norm_cuts_segm(Im, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
Im_segmented = mean_segments(Iback, Image_segmented);
Im_overlay = overlay_bounds(Iback, Image_segmented);

% ------- Plotting ------- %
figure

subplot(1, 2, 1);
imshow(Im_segmented); 
title('Resulting segmentation');

subplot(1, 2, 2); 
imshow(Im_overlay); 
title('Overlay');

%% GRAPH CUT ALGORITHM

% Cleaning up
clear; close all;

% -------------------- Parameters -------------------- %
K = 15;                      % Number of gaussian components
alpha = 16.0;                % Max edge cost
sigma = 8.0;                % Edge cost decay
scale_factor = 0.6;          % Factor for down-scale operation
% ---------------------------------------------------- %

% Loading in the image and prepping it
Im = imread('tiger1.jpg');
I_resized = imresize(Im, scale_factor);
I_temp = I_resized;

% Determining the foreground and scaling it
foreground = [85, 115, 575, 305];  
foreground_scaled = int16(foreground * scale_factor); 

% Performing segmentation and using a custom mean algorithm
[Image_segmented, prior] = graphcut_segm(I_resized, foreground_scaled, K, alpha, sigma);
Im_segmented = mean_segm(I_temp, Image_segmented);
Im_overlay = overlay_bounds(I_temp, Image_segmented);

% ------- Plotting ------- %
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
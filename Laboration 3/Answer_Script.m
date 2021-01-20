%% Answer script for Lab 3
% Author: David Dashti
% Date: 2021-01-20

%% K-MEANS ALGORITHM


% -------------------- Parameters -------------------- %
K = 10;              % Number of clusters
L = 20;              % Number of iterations
seed = 1337;         % Seed
scale_factor = 0.5;  % Factor for down-scale operation
image_sigma = 1.0;   % Blurring factor
thresh = 0.01;       % Threshold to stop segmentation
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
[segm, centers, counter] = kmeans_segm(I_input, K, L, seed, thresh);

I_segmented = mean_segments(I_temp, segm);
I_resized = overlay_bounds(I_temp, segm);

% ------- Plotting ------- %
figure
subplot(1,3,1)
imshow(Im);
title('Original image')

subplot(1,3,2)
imshow(I_segmented);
title(sprintf('Segmented image with K = %d', K))

subplot(1,3,3)
imshow(I_resized);
title('Segmentation overlayed on the original image')

%% MEAN-SHIFT ALGORITHM

close all
clear

% -------------------- Parameters -------------------- %
spatial_bandwidth = 30.0;  % Spatial bandwidth
colour_bandwidth = 5.0;    % Colour bandwidth
num_iterations = 40;       % Number of iterations
image_sigma = 1.0;         % Blurring factor
scale_factor = 0.5;        % Factor for down-scale operation
% ---------------------------------------------------- %

img_name = 'orange';
img_path = strcat(img_name,'.jpg');
I = imread(img_path);
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

segm = mean_shift_segm(I, spatial_bandwidth, colour_bandwidth, num_iterations);
Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);

out_mean_1_path = 'lab3/result/meanshift1_';
out_mean_1_path_img = strcat(out_mean_1_path,img_path);

out_mean_2_path = 'lab3/result/meanshift2_';
out_mean_2_path_img = strcat(out_mean_2_path,img_path);

imwrite(Inew, out_mean_1_path_img);
imwrite(I,out_mean_2_path_img);

subplot(1,2,1); imshow(Inew); 
title(['\sigma^2_{s} = ', num2str(spatial_bandwidth), ', \sigma^2_{c} = ', num2str(colour_bandwidth)])

subplot(1,2,2); imshow(I);
title('Org. img, with overlay')

%% NORMALIZED CUT ALGORITHM

close all
clear

% -------------------- Parameters -------------------- %
colour_bandwidth = 15.0;   % color bandwidth
radius = 10;               % maximum neighbourhood distance
ncuts_thresh = 0.5;        % cutting threshold
min_area = 10;             % minimum area of segment
max_depth = 10;            % maximum splitting depth
image_sigma = 2.0;         % Blurring factor
scale_factor = 0.4;        % Factor for down-scale operation
% ---------------------------------------------------- %

I = imread('tiger3.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);
imwrite(Inew,'lab3/result/normcuts1_3.png')
imwrite(I,'lab3/result/normcuts2_3.png')

figure
subplot(1,2,1); imshow(Inew); title('Resulting segmentation');
subplot(1,2,2); imshow(I); title('Overlay bounds using Normalized Cut');

%% GRAPH CUT ALGORITHM

close all
clear

% -------------------- Parameters -------------------- %
% image region to train foreground with
area = [ 80, 110, 570, 300 ];  %tiger1
K = 20;                      % number of mixture components
alpha = 15.0;                 % maximum edge cost
sigma = 10.0;                % edge cost decay factor
scale_factor = 0.5;          % Factor for down-scale operation
% ---------------------------------------------------- %

I = imread('tiger1.jpg');
I_resized = imresize(I, scale_factor);
Iback = I_resized;

area_scaled = int16(area*scale_factor); 
[segm, prior] = graphcut_segm(I_resized, area_scaled, K, alpha, sigma);

Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);
imwrite(Inew,'lab3/result/gcut1.png')
imwrite(I,'lab3/result/gcut2.png')
imwrite(prior,'lab3/result/gcut3.png')
subplot(2,2,1); imshow(Inew); title('Resulting segmentation');
subplot(2,2,2); imshow(I); title('Overlay bounds using Graph Cut');
subplot(2,2,3); imshow(prior); title('Prior foreground probabilities');

function segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh, max_area, max_depth)

tic
[nRow, nCol, c] = size(I);
N = nRow * nCol;
V = reshape(I, N, c); % connect up-to-down way. Vertices of Graph

fprintf('Compute affinity matrix...\n');
W = ncuts_affinity(I, radius, colour_bandwidth);
toc 

fprintf('Solve eigenvalue problems to find partitions...\n');
Seg = (1:N)'; 
[Seg, Id, Ncut] = ncuts_partition(Seg, W, ncuts_thresh, max_area, 'ROOT', max_depth, 1);

segm = zeros(nRow*nCol, 1);
for i=1:length(Seg)
    segm(Seg{i}) = i;
    fprintf('%s. Ncut = %f\n', Id{i}, Ncut{i});
end

segm = uint32(reshape(segm, nRow, nCol));
toc

% segmentation_algorithms_demo.m
% Demonstration of various image segmentation algorithms

%% K-means Segmentation

K = 8;                % Number of clusters
L = 15;               % Number of iterations
seed = 1337;          % Random seed
scale_factor = 0.6;   % Image downscale factor
image_sigma = 1.0;    % Gaussian blur sigma
thresh = 0.02;        % Convergence threshold

Im = imread('orange.jpg');
Im_resized = imresize(Im, scale_factor);

% Gaussian smoothing
d = 2 * ceil(image_sigma * 2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
Im_blur = imfilter(Im_resized, h);

% K-means segmentation
[segmentation, centers, ~] = kmeans_segm(Im_blur, K, L, seed, thresh);
Im_segmented = mean_segm(Im_resized, segmentation);
Im_overlay = overlay_bounds(Im_resized, segmentation);

figure;
subplot(1, 3, 1); imshow(Im); title('Original image');
subplot(1, 3, 2); imshow(Im_segmented); title('Segmented image');
subplot(1, 3, 3); imshow(Im_overlay); title('Segmentation overlay');

%% Mean-Shift Segmentation

clearvars -except Im; close all;

spatial_bandwidth = 25.0;
colour_bandwidth = 6.0;
num_iterations = 45;
image_sigma = 1.0;
scale_factor = 0.6;

Im = imread('orange.jpg');
Im_resized = imresize(Im, scale_factor);

d = 2 * ceil(image_sigma * 2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
Im_blur = imfilter(Im_resized, h);

segmentation = mean_shift_segm(Im, spatial_bandwidth, colour_bandwidth, num_iterations);
Im_segmented = mean_segm(Im_resized, segmentation);
Im_overlay = overlay_bounds(Im_resized, segmentation);

figure;
subplot(1,2,1); imshow(Im_segmented); title('Segmented image');
subplot(1,2,2); imshow(Im_overlay); title('Segmentation overlay');

%% Normalized Cuts Segmentation

clearvars -except Im; close all;

colour_bandwidth = 17.0;
radius = 12;
ncuts_thresh = 0.4;
min_area = 15;
max_depth = 15;
image_sigma = 1.5;
scale_factor = 0.6;

Im = imread('tiger2.jpg');
Im_resized = imresize(Im, scale_factor);

d = 2 * ceil(image_sigma * 2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
Im_blur = imfilter(Im_resized, h);

segmentation = norm_cuts_segm(Im_blur, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
Im_segmented = mean_segm(Im_resized, segmentation);
Im_overlay = overlay_bounds(Im_resized, segmentation);

figure;
subplot(1, 2, 1); imshow(Im_segmented); title('Segmented image');
subplot(1, 2, 2); imshow(Im_overlay); title('Segmentation overlay');

%% Graph Cut Segmentation

clearvars -except Im; close all;

K = 15;                % Number of Gaussian components
alpha = 16.0;          % Max edge cost
sigma = 8.0;           % Edge cost decay
scale_factor = 0.6;

Im = imread('tiger1.jpg');
Im_resized = imresize(Im, scale_factor);

foreground = [85, 115, 575, 305];
foreground_scaled = int16(foreground * scale_factor);

[segmentation, prior] = graphcut_segm(Im_resized, foreground_scaled, K, alpha, sigma);
Im_segmented = mean_segm(Im_resized, segmentation);
Im_overlay = overlay_bounds(Im_resized, segmentation);

figure;
subplot(1, 3, 1); imshow(Im_segmented); title('Segmented image');
subplot(1, 3, 2); imshow(Im_overlay); title('Segmentation overlay');
subplot(1, 3, 3); imshow(prior, []); title('Prior foreground probabilities');


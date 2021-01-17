%% Q.1 Initialization of clustering process - why good method of doing it?
    %Try to modify
        %K - number of cluster centeers
        %L - number of iterations
        %scale_factor - image downscale factor
        %sigma - amount of pre-blurring 

%% Q.3 What's the min value for K, w/o gettign any superpixels that cover
    %parts from both halves of the orange
close all
clear

% ------- Parameters ------- %

K = 10;              %number of clusters used
L = 20;              %number of iterations
seed = 1337;         %seed used for random initialization
scale_factor = 0.5;  %image downscale factor
image_sigma = 1.0;   %image preblurring scale
threshold = 0.01;

% -------------------------- %

i = 1;
I_org = imread('tiger1.jpg');

I = imresize(I_org, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I_in = imfilter(I, h);
UNTIL_CONVERGENCE = true;

figure
subplot(1,3,1)
imshow(I_org);
title('Original')

[segm, centers, counter] = kmeans_segm(I_in, K, L, seed, UNTIL_CONVERGENCE, threshold);
counter
Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);

subplot(1,3,2)
imshow(Inew);
title(sprintf('Clustered, K = %d', K))

subplot(1,3,3)
imshow(I);
title('Divided into superpixels - Overlay')
    
%% Q.3.1 Generate several segmentations with varying K for comparison
close all
clear

% ------- Parameters ------- %

K = 8;               %number of clusters used
L = 20;              %number of iterations
seed = 1337;         %seed used for random initialization
scale_factor = 0.5;  %image downscale factor
image_sigma = 1.0;   %image preblurring scale
threshold = 0.01;

% -------------------------- %

i = 1;
I_org = imread('orange.jpg');

I = imresize(I_org, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I_in = imfilter(I, h);

i = 1;

figure
for k=2:3
    subplot(2,3,i)
    imshow(I_org);
    title('Original')

    [segm, centers, counter] = kmeans_segm(I_in, k, L, seed, false, threshold);
    counter
    Inew = mean_segments(Iback, segm);
    I = overlay_bounds(Iback, segm);
    
    subplot(2,3,i+1)
    imshow(Inew);
    title(sprintf('Clustered, K = %d', k))
    
    subplot(2,3,i+2)
    imshow(I);
    title('Divided into superpixels - Overlay')
    
    i = i+3;
end
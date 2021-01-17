%LAB 3 - Jonathan Rintala
%// 3. MEAN-SHIFT SEGMENTATION

close all
clear

%--------------------Parameters-------------------------
scale_factor = 0.5;         % image downscale factor
spatial_bandwidth = 30.0;   % spatial bandwidth
colour_bandwidth = 5.0;     % colour bandwidth
num_iterations = 40;        % number of mean-shift iterations
image_sigma = 1.0;          % image preblurring scale
%-------------------------------------------------------

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

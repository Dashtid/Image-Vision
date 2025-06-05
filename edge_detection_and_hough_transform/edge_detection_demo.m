% edge_detection_demo.m
% Demonstration of edge detection, gradient operations, and Hough transform

%% Sobel Difference Operators
% Apply Sobel filters to the 'tools' image to compute gradients in x and y directions

tools = few256; % Load the 'tools' test image

deltax = [1, 0, -1; 2, 0, -2; 1, 0, -1]; % Sobel kernel for x-direction
deltay = [1, 2, 1; 0, 0, 0; -1, -2, -1]; % Sobel kernel for y-direction

dxtools = conv2(tools, deltax, 'valid'); % Convolve image with x kernel
dytools = conv2(tools, deltay, 'valid'); % Convolve image with y kernel

figure;
subplot(2, 2, 1); showgrey(tools); title("Original image");
subplot(2, 2, 2); showgrey(dxtools); title("Convolution with deltax");
subplot(2, 2, 3); showgrey(dytools); title("Convolution with deltay");
subplot(2, 2, 4); showgrey(dxtools + dytools); title("Sum of convolutions");
sgtitle("Sobel Difference Operator Results");

%% Point-wise Thresholding of Gradient Magnitudes
% Visualize thresholding of gradient magnitudes for edge detection

plotThresh(2, few256, [100, 150], 0, "few256");
plotThresh(3, few256, [100, 150], 0.5, "few256");
plotThresh(4, godthem256, [100, 150], 0, "godthem256");
plotThresh(5, godthem256, [50, 70], 2, "godthem256");

%% Differential Geometry Descriptors
% Visualize zero-crossings and curvature-based edge descriptors at multiple scales

house = godthem256;
tools = few256;
scale = [0.0001, 1.0, 4.0, 32.0, 64.0];

plotFunction(6, house, scale, 0, "House", "Lvv = 0");
plotFunction(7, house, scale, 1, "House", "Lvvv < 0");
plotFunction(8, house, scale, 2, "House", "Lvv = 0 & Lvvv < 0");
plotFunction(9, tools, scale, 0, "Tools", "Lvv = 0");
plotFunction(10, tools, scale, 1, "Tools", "Lvvv < 0");
plotFunction(11, tools, scale, 2, "Tools", "Lvv = 0 & Lvvv < 0");

%% Edge Segment Extraction
% Extract and overlay edge segments using scale-space edge detection

house = godthem256;
tools = few256;
scale = [5, 10];
threshold = [250 , 1000];

figure;
subplot(1, 2, 1);
curves = extractedge(house, scale(1), threshold(1), 'same');
overlaycurves(house, curves);
title("Scale = " + scale(1) + " Threshold = " + threshold(1));

subplot(1, 2, 2);
curves = extractedge(tools, scale(2), threshold(2), 'same');
overlaycurves(tools, curves);
title("Scale = " + scale(2) + " Threshold = " + threshold(2));
sgtitle("Edges of House & Tools");

%% Hough Transform and Line Detection
% Detect and overlay straight lines using the Hough transform

test = houghtest256;
tools = few256;
phone = phonecalc256;
house = godthem256;

houghedgeline(test, 10, 10, 1000, 1000, 10, 1);

figure;
houghedgeline(tools, 5, 10, 1000, 60, 10, 0);

figure;
houghedgeline(house, 5, 20, 1000, 60, 9, 0);

figure;
houghedgeline(phone, 5, 10, 800, 60, 12, 0);


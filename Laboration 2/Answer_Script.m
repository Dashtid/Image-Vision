%% Question 1: Difference Operators

% Loading images
tools = few256;

% Convolution matrixes for Sobel Difference Operator
deltax = [1, 0, -1; 2, 0, -2; 1, 0, -1];
deltay = [1, 2, 1; 0, 0, 0; -1, -2, -1];

% Convolution with above difference operators, 'valid' tells us that the
% parts with zero padded edges are not in the return matrix
% This will result in 256 * 256 (from 254 * 254)
dxtools = conv2(tools, deltax, 'valid'); 
dytools = conv2(tools, deltay, 'valid');

%Plotting all the matrixes
figure(1)

subplot(2, 2, 1)
showgrey(tools)
title("The original image")

subplot(2, 2, 2);
showgrey(dxtools)
title("Convolution with deltax")

subplot(2, 2, 3)
showgrey(dytools)
title("Convolution with delta y")

subplot(2, 2, 4)
showgrey(dxtools + dytools)
title("The two matrixes added together")

sgtitle("Results of using the Sobel Difference Operator")

%% Question 2 - 3: Point-wise thresholding of gradient magnitudes

% Image: few256
plotThresh(2, few256, [100, 150], 0, "few256");
plotThresh(3, few256, [100, 150], 0.5, "few256");

% Image: godthem256
plotThresh(4, godthem256, [100, 150], 0, "godthem256");
plotThresh(5, godthem256, [50, 70], 2, "godthem256");

%% Question 4 - 6: Computing differential geometry descriptors 

% The images I am testing on
house = godthem256;
tools = few256;

% Scale given by instructions
scale = [0.0001, 1.0, 4.0, 32.0, 64.0];

% Image: House
plotFunction(6, house, scale, 0, "House", "Lvv = 0")
plotFunction(7, house, scale, 1, "House", "Lvvv < 0")
plotFunction(8, house, scale, 2, "House", "Lvv = 0 & Lvvv < 0")

% Image: Tools
plotFunction(9, tools, scale, 0, "Tools", "Lvv = 0")
plotFunction(10, tools, scale, 1, "Tools", "Lvvv < 0")
plotFunction(11, tools, scale, 2, "Tools", "Lvv = 0 & Lvvv < 0")

%% Question 7: Extraction of edge segments

% The images I am testing on
house = godthem256;
tools = few256;

% Scales and thresholds
scale = [5, 10];
treshold = [250 , 1000];

% Creating the figure
figure(13)

% Image: House
subplot(1, 2, 1);
curves = extractedge(house, scale(1), treshold(1), 'same');
overlaycurves(house, curves);
title("Scale = " + scale(1) + " Threshold = " + treshold(1))

 
% Image: Tools
subplot(1, 2, 2);
curves = extractedge(tools, scale(2), treshold(2), 'same');
overlaycurves(tools, curves);
title("Scale = " + scale(2) + " Threshold = " + treshold(2))

sgtitle("Edges of House & Tools")


%% Question 8 - 10: Hough transform
% Code for question 10 can be found inside houghline function

% Images
test = houghtest256;
tools = few256;
phone = phonecalc256;
house = godthem256;

% ------  Those are the parameters below ------ %  
% Houghedeline(img, scale, gradmagnthershold, ...
% nrho, nthetha, nlines, verbose)

houghedgeline(test, 10, 10, 1000, 1000, 10, 1);

figure()
houghedgeline(tools, 5, 10, 1000, 60, 10, 0);

figure()
houghedgeline(house, 5, 20, 1000, 60, 9, 0);
 
figure()
houghedgeline(phone, 5, 10, 800, 60, 12, 0);


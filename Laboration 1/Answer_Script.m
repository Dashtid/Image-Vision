% Laboration 1: Filtering Operations
% David Dashti

%% Question 1-4: Properties of DFT. 

%Creating a list with the points wanted
Points = [9,5; 5,9; 17,9; 17,121; 5,1; 125,1];

%Running each point through a loop to generate 6 figures
for i = 1:size(Points, 1)
   figure(i)
   fftwave( Points(i, 1), Points(i, 2) );
end
%% Question 5 - 6: Properties of DFT

%Showing how the centering operation is done by two plot examples
figure(8);
fftwave(1, 65);
suptitle("What happens when u is very small and v is just above sz");

figure(9);
fftwave(65, 127);
suptitle("What happens when u is just above sz and v is almost sz");

%% Question 7 - 9: Linearity

%Creating the matrixes they wanted
F = [ zeros(56, 128); ones(16, 128); zeros(56, 128)];
G = F';
H = F + 2 * G;

%Doing fourier on the matrixes
Fhat = fft2(F);
Ghat = fft2(G);
Hhat = fft2(H);

%Plotting the three matrixes
figure(11)

%Shows the matrix F
subplot(3, 3, 1);
showgrey(F);
title('F')

%Shows the matrix G
subplot(3, 3, 2);
showgrey(G);
title('G')

%Show the combined matrix
subplot(3, 3, 3);
showgrey(H);
title('H')

%Shows the logarithmic version of Fhat
subplot(3, 3, 4);
showgrey(log(1 + abs(Fhat)));
title('Log of Fhat')
subplot(3, 3, 5);

%Shows the logarithmic version of Ghat
showgrey(log(1 + abs(Ghat)));
title('Log of Ghat')
subplot(3, 3, 6);

%Shows the logarithmic version of Hhat
showgrey(log(1 + abs(Hhat)));
title('Log of Hhat')

%Shows the logarithmic and then centered version of F
subplot(3, 3, 7);
showgrey(log(1 + abs(fftshift(Hhat))));
title('Showgray for log centered Hhat')

%Used to illustrate that log help show alot more frequencies
subplot(3, 3, 8);
showgrey(F .* G);
title('Showgray for to F.*G illustrate difference between log and non-log')

%% Question 10

figure(12)

%The one asked for
subplot(2, 2, 1);
showgrey(F.*G);
title('F.*G')

%The one asked for
subplot(2, 2, 2);
showfs(fft2(F.*G));
title('Fourier of F.*G')

%Shows how the original image can be returned through first convolution of each fourier transforms
%and then the inverse of that 
subplot(2, 2, 3);
showgrey(abs(ifft2(conv2(fftshift(Fhat),fftshift(Ghat),'same'))));
title('Convolution of Fhat, Ghat and then inversed')

subplot(2, 2, 4);
showfs(fftshift((1/(128*128))*conv2(fftshift(Fhat),fftshift(Ghat),'same')));
title('Convolution of Fhat, Ghat')


%% Question 11 - 12

%The matrix they wanted
F = [zeros(60, 128); ones(8, 128); zeros(60, 128)] .* ...
[zeros(128, 48) ones(128, 32) zeros(128, 48)];

figure(13)

%Plotting the matrix so one can see what is done to it
subplot(2, 3, 1);
showgrey(F);
title('F');

%Plotting the Fourier
subplot(2, 3, 2);
showfs(fft2(F));
title('Fourier of F')

%Setting up rotation variables
alpha = 30;
G = rot(F, alpha);

%Rotating the matrix 30 degrees
subplot(2, 3, 3);
showgrey(G);
title('Rotation of 30 degrees')

%Creating the fourier of the rotated matrix
Ghat = fft2(G);

%Plotting the rotated matrix
subplot(2, 3, 4);
showfs(Ghat);
title('The fourier of the rotated matrix')

%Centering and rotating the fourier in the other direction
Hhat = rot(fftshift(Ghat), -alpha);

subplot(2, 3, 5);
showgrey(log(1 + abs(Hhat)));
title('Logarithmic of Fourier rotated back')

%% Question 13 

%Setting up the variables needed for the loop
img{1} = phonecalc128;
img{2} = few128;
img{3} = nallo128;
names_of_images = ["phonecalc128", "few128", "nallo128"];
a = 10^-10;


figure(14);
for i = 1:3  
    
    % Plotting all the images
    subplot(3, 3, i)
    showgrey(img{i});
    title(names_of_images(1, i));
    
    % This function changes the magnitude with the parameter a 
    subplot(3,3, 3 + i)
    showgrey(pow2image(img{i}, a));
    title("Changing magnitude abit");
    
    % This randomizes the distribution of the phase but keeps the magnitude
    subplot(3,3, 6 + i)
    showgrey(randphaseimage(img{i}));
    title("Randomizing phase");
end

%% Question 14 - 15: Gaussian filtering using FFT

%Im creating 5 figures for this one with one of these values for each
variance_values = [0.1, 0.3, 1.0, 10.0, 100.0];

%This figure will be template, rest is done the same way
figure(15)

%Calculate the Fourier of the gaussian % delta pulse.
%Also calculates the variance matrix
Gauss = gaussfft(deltafcn(128, 128), variance_values(1));
variance_matrix_1 = variance(Gauss);

%Plotting the Fourier of the gaussian % delta pulse in 3D.
subplot(1,2,1)
surf(Gauss);

%Centers the Fourier of the gaussian % delta pulse.
subplot(1,2,2)
showfs(fftshift(Gauss));
suptitle(['Variance of: ',num2str(variance_values(1))]);

%The rest of the figures are done exactly like the one above and in
%retrospect I should have used a loop to do all of this but I was not
%really sharp at the time i wrote this question
figure(16)
Gauss = gaussfft(deltafcn(128, 128), variance_values(2));
variance_matrix_2 = variance(Gauss);
subplot(1,2,1)
surf(Gauss);
subplot(1,2,2)
showfs(fftshift(Gauss));
suptitle(['Variance of: ',num2str(variance_values(2))]);

figure(17)
Gauss = gaussfft(deltafcn(128, 128), variance_values(3));
variance_matrix_3 = variance(Gauss);
subplot(1,2,1)
surf(Gauss);
subplot(1,2,2)
showfs(fftshift(Gauss));
suptitle(['Variance of: ',num2str(variance_values(3))]);

figure(18)
Gauss = gaussfft(deltafcn(128, 128), variance_values(4));
variance_matrix_4 = variance(Gauss);
subplot(1,2,1)
surf(Gauss);
subplot(1,2,2)
showfs(fftshift(Gauss));
suptitle(['Variance of: ',num2str(variance_values(4))]);

figure(19)
Gauss = gaussfft(deltafcn(128, 128), variance_values(5));
variance_matrix_5 = variance(Gauss);
subplot(1,2,1)
surf(Gauss);
subplot(1,2,2)
showfs(fftshift(Gauss));
suptitle(['Variance of: ',num2str(variance_values(5))]);

%% Question 16 

%Basically setting up variables
new_variance_values = [1.0, 4.0, 16.0, 64.0, 256.0];
l = length(new_variance_values);

%Doing the convolution with gaussian filter and two different images at different
%variances

figure(20);
for i = 1:l
Gauss = gaussfft(phonecalc128, new_variance_values(i));
subplot(2, 3, i);
showfs(fftshift(Gauss));
title(['Variance of: ',num2str(new_variance_values(i))]);
end
suptitle("phonecalc128 convolved with gauss and different variances");

figure(21);
for i = 1:l
Gauss = gaussfft(few128, new_variance_values(i));
subplot(2, 3, i);
showfs(fftshift(Gauss));
title(['Variance of: ',num2str(new_variance_values(i))]);
end
suptitle("few128 convolved with gauss and different variances");

%% Question 17 - 18: Smoothing

office = office256;

%Two noisy images
add = gaussnoise(office, 16);  
sap = sapnoise(office, 0.1, 255);

%List of the images and the names
images = {office, add, sap};
names_of_images = ["office256", "gaussnoise", "sapnoise"];

%Showing the three images for starters
figure(23);
for i = 1:3
    subplot(1,3,i);
    showgrey(images{i});
    title(names_of_images{i});
end
suptitle("The three images, obviously increasing noise");


%Now I try to tidy up add & sap

% TIDYING ADD %

%List of variances, window sizes and cut-off frequencies
variances = [0.1, 1, 10];
window_sizes = [5, 10, 15];
cut_off_freq = [0.01, 0.1, 0.5];

%Tidying up add w. gaussfft
figure(23);
for i = 1:3
    subplot(1,3,i);
    showgrey(gaussfft(add,variances(i)));
    title(['Variance of: ',num2str(variances(i))]);
end
suptitle("Add w. gaussian filter @ different variances");

%Tidying up add w. medfilt
figure(24);
for i = 1:3
    subplot(1,3,i);
    showgrey(medfilt(add,window_sizes(i)));
    title(['Window size of: ',num2str(window_sizes(i))]);
end
suptitle("Add w. median filter @ different window sizes");

%Tidying up add w. ideal
figure(25);
for i = 1:3
    subplot(1,3,i);
    showgrey(ideal(add,cut_off_freq(i)));
    title(['Cut-off freq. of: ',num2str(cut_off_freq(i))]);
end
suptitle("Add w. ideal low-pass filter @ different cut-off freq.");

% TIDYING SAP %

%Tidying up sap w. gaussfft
figure(26);
for i = 1:3
    subplot(1,3,i);
    showgrey(gaussfft(sap,variances(i)));
    title(['Variance of: ',num2str(variances(i))]);
end
suptitle("Sap w. gaussian filter @ different variances");

%Tidying up sap w. medfilt
figure(27);
for i = 1:3
    subplot(1,3,i);
    showgrey(medfilt(sap,window_sizes(i)));
    title(['Window size of: ',num2str(window_sizes(i))]);
end
suptitle("Sap w. median filter @ different window sizes");

%Tidying up sap w. gaussfft
figure(28);
for i = 1:3
    subplot(1,3,i);
    showgrey(ideal(sap,cut_off_freq(i)));
    title(['Cut-off freq. of: ',num2str(cut_off_freq(i))]);
end
suptitle("Sap w. ideal low-pass filter @ different cut-off freq.");

%% Question 19 - 20: Smoothing and Subsampling

%Setting up variables
img = phonecalc256;
smooth_gauss = img;
smooth_ideal_lp = img;


for i = 1:5   
    
%Filter convolution
smooth_gauss = gaussfft(smooth_gauss, 0.5);
smooth_ideal_lp = ideal(smooth_ideal_lp, 0.3);

%Subsampling for all
img = rawsubsample(img);
smooth_gauss = rawsubsample(smooth_gauss);
smooth_ideal_lp = rawsubsample(smooth_ideal_lp);

%Plotting all the subsampled images without smoothing
subplot(3, 5, i);
showgrey(img);
title(['Only subsample, i = ',num2str(i)]);

%Plotting all the subsampled images that has gone through a gauss filter
subplot(3, 5, i + 5);
showgrey(smooth_gauss);
title(['Subsample w. gauss, i = ',num2str(i)])

%Plotting all the subsampled images that has gone through a ideal lp filter
subplot(3, 5, i + 10); 
showgrey(smooth_ideal_lp);
title(['Subsample w. ideal lp, i = ',num2str(i)]);
end

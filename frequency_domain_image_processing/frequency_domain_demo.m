% Filtering Operations in the Frequency Domain

%% Properties of DFT
% Visualize the effect of different frequency components using fftwave

points = [9,5; 5,9; 17,9; 17,121; 5,1; 125,1]; % (u,v) frequency points

for i = 1:size(points, 1)
    figure(i)
    fftwave(points(i, 1), points(i, 2));
end
%% Centering Operation in DFT
% Explore the effect of frequencies near the image size

figure(8);
fftwave(1, 65);
suptitle("What happens when u is very small and v is just above sz");

figure(9);
fftwave(65, 127);
suptitle("What happens when u is just above sz and v is almost sz");

%% Question 7-9: Linearity
% Demonstrate linearity of the Fourier transform

F = [zeros(56, 128); ones(16, 128); zeros(56, 128)]; % Horizontal bar
G = F';                                              % Vertical bar
H = F + 2 * G;                                       % Linear combination

Fhat = fft2(F);
Ghat = fft2(G);
Hhat = fft2(H);

figure(11)
subplot(3, 3, 1); showgrey(F); title('F');
subplot(3, 3, 2); showgrey(G); title('G');
subplot(3, 3, 3); showgrey(H); title('H');
subplot(3, 3, 4); showgrey(log(1 + abs(Fhat))); title('Log of Fhat');
subplot(3, 3, 5); showgrey(log(1 + abs(Ghat))); title('Log of Ghat');
subplot(3, 3, 6); showgrey(log(1 + abs(Hhat))); title('Log of Hhat');
subplot(3, 3, 7); showgrey(log(1 + abs(fftshift(Hhat)))); title('Log centered Hhat');
subplot(3, 3, 8); showgrey(F .* G); title('F .* G');

%% Multiplication and Convolution
% Show the relationship between multiplication and convolution in the frequency domain

figure(12)
subplot(2, 2, 1); showgrey(F.*G); title('F.*G');
subplot(2, 2, 2); showfs(fft2(F.*G)); title('Fourier of F.*G');
subplot(2, 2, 3); showgrey(abs(ifft2(conv2(fftshift(Fhat), fftshift(Ghat), 'same'))));
title('Convolution of Fhat, Ghat and then inversed');
subplot(2, 2, 4); showfs(fftshift((1/(128*128))*conv2(fftshift(Fhat), fftshift(Ghat), 'same')));
title('Convolution of Fhat, Ghat');

%% Question 11-12: Rotation and Fourier
% Investigate how rotation in the spatial domain affects the frequency domain

F = [zeros(60, 128); ones(8, 128); zeros(60, 128)] .* ...
    [zeros(128, 48) ones(128, 32) zeros(128, 48)]; % Rectangle

figure(13)
subplot(2, 3, 1); showgrey(F); title('F');
subplot(2, 3, 2); showfs(fft2(F)); title('Fourier of F');

alpha = 30; % Rotation angle
G = rot(F, alpha);
subplot(2, 3, 3); showgrey(G); title('Rotation of 30 degrees');

Ghat = fft2(G);
subplot(2, 3, 4); showfs(Ghat); title('Fourier of rotated matrix');

Hhat = rot(fftshift(Ghat), -alpha);
subplot(2, 3, 5); showgrey(log(1 + abs(Hhat))); title('Logarithmic of Fourier rotated back');

%% Magnitude and Phase Manipulation
% Explore the effect of changing magnitude and phase in the frequency domain

img{1} = phonecalc128;
img{2} = few128;
img{3} = nallo128;
names_of_images = ["phonecalc128", "few128", "nallo128"];
a = 1e-10; % Small value for magnitude manipulation

figure(14);
for i = 1:3  
    subplot(3, 3, i); showgrey(img{i}); title(names_of_images(i));
    subplot(3, 3, 3 + i); showgrey(pow2image(img{i}, a)); title("Changing magnitude");
    subplot(3, 3, 6 + i); showgrey(randphaseimage(img{i})); title("Randomizing phase");
end

%% Gaussian Filtering using FFT
% Visualize Gaussian filters in the frequency domain for different variances

variance_values = [0.1, 0.3, 1.0, 10.0, 100.0];

for idx = 1:length(variance_values)
    figure(14 + idx)
    Gauss = gaussfft(deltafcn(128, 128), variance_values(idx));
    subplot(1,2,1); surf(Gauss);
    subplot(1,2,2); showfs(fftshift(Gauss));
    suptitle(['Variance of: ', num2str(variance_values(idx))]);
end

%% Gaussian Filtering of Images
% Apply Gaussian filtering to images with different variances

new_variance_values = [1.0, 4.0, 16.0, 64.0, 256.0];
l = length(new_variance_values);

figure(20);
for i = 1:l
    Gauss = gaussfft(phonecalc128, new_variance_values(i));
    subplot(2, 3, i); showfs(fftshift(Gauss));
    title(['Variance: ', num2str(new_variance_values(i))]);
end
suptitle("phonecalc128 convolved with gauss, different variances");

figure(21);
for i = 1:l
    Gauss = gaussfft(few128, new_variance_values(i));
    subplot(2, 3, i); showfs(fftshift(Gauss));
    title(['Variance: ', num2str(new_variance_values(i))]);
end
suptitle("few128 convolved with gauss, different variances");

%% Smoothing
% Compare different smoothing techniques on noisy images

office = office256;
add = gaussnoise(office, 16);  
sap = sapnoise(office, 0.1, 255);

images = {office, add, sap};
names_of_images = ["office256", "gaussnoise", "sapnoise"];

figure(23);
for i = 1:3
    subplot(1,3,i); showgrey(images{i}); title(names_of_images(i));
end
suptitle("Three images, increasing noise");

% Gaussian smoothing
variances = [0.1, 1, 10];
figure(24);
for i = 1:3
    subplot(1,3,i); showgrey(gaussfft(add, variances(i)));
    title(['Variance: ', num2str(variances(i))]);
end
suptitle("Add with gaussian filter, different variances");

% Median filter
window_sizes = [5, 10, 15];
figure(25);
for i = 1:3
    subplot(1,3,i); showgrey(medfilt(add, window_sizes(i)));
    title(['Window size: ', num2str(window_sizes(i))]);
end
suptitle("Add with median filter, different window sizes");

% Ideal low-pass filter
cut_off_freq = [0.01, 0.1, 0.5];
figure(26);
for i = 1:3
    subplot(1,3,i); showgrey(ideal(add, cut_off_freq(i)));
    title(['Cut-off freq: ', num2str(cut_off_freq(i))]);
end
suptitle("Add with ideal low-pass filter, different cut-off freq");

% Repeat for sap noise
figure(27);
for i = 1:3
    subplot(1,3,i); showgrey(gaussfft(sap, variances(i)));
    title(['Variance: ', num2str(variances(i))]);
end
suptitle("Sap with gaussian filter, different variances");

figure(28);
for i = 1:3
    subplot(1,3,i); showgrey(medfilt(sap, window_sizes(i)));
    title(['Window size: ', num2str(window_sizes(i))]);
end
suptitle("Sap with median filter, different window sizes");

figure(29);
for i = 1:3
    subplot(1,3,i); showgrey(ideal(sap, cut_off_freq(i)));
    title(['Cut-off freq: ', num2str(cut_off_freq(i))]);
end
suptitle("Sap with ideal low-pass filter, different cut-off freq");

%% Smoothing and Subsampling
% Show the effect of smoothing before subsampling

img = phonecalc256;
smooth_gauss = img;
smooth_ideal_lp = img;

figure(30);
for i = 1:5   
    % Filter convolution
    smooth_gauss = gaussfft(smooth_gauss, 0.5);
    smooth_ideal_lp = ideal(smooth_ideal_lp, 0.3);

    % Subsampling
    img = rawsubsample(img);
    smooth_gauss = rawsubsample(smooth_gauss);
    smooth_ideal_lp = rawsubsample(smooth_ideal_lp);

    % Plotting
    subplot(3, 5, i); showgrey(img); title(['Only subsample, i = ', num2str(i)]);
    subplot(3, 5, i + 5); showgrey(smooth_gauss); title(['Subsample w. gauss, i = ', num2str(i)]);
    subplot(3, 5, i + 10); showgrey(smooth_ideal_lp); title(['Subsample w. ideal lp, i = ', num2str(i)]);
end

% --- Helper Function: Gaussian Filtering in Frequency Domain --- %
function Gauss = gaussfft(pic, t)
%GAUSSFFT Applies a Gaussian filter in the frequency domain.
%   Gauss = gaussfft(pic, t) convolves the image 'pic' with a Gaussian
%   filter of variance 't' using FFT.

    [row, col] = size(pic);

    % Create axis values centered at zero
    x = -(row/2):(row/2)-1;
    y = -(col/2):(col/2)-1;

    % Create meshgrid for Gaussian
    [X, Y] = meshgrid(x, y);

    % Create Gaussian filter
    G = (1/(2 * pi * t)) * exp(-(X.^2 + Y.^2) / (2 * t));

    % Fourier transforms
    Pic_hat = fft2(pic);
    Ghat = fft2(fftshift(G));

    % Multiply in frequency domain and inverse FFT to get filtered image
    Gauss = ifft2(Pic_hat .* Ghat);
end

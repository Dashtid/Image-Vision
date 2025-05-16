function fftwave(u, v, sz)
% FFTWAVE  Visualize a 2D Fourier basis function (complex exponential)
%   fftwave(u, v, sz) displays the real part, imaginary part, and magnitude
%   of the 2D complex exponential with frequencies (u, v) on a sz x sz grid.
%
%   u, v : frequency indices (integers)
%   sz   : (optional) image size (default: 128)

    if nargin < 3
        sz = 128;
    end

    % Create coordinate grid
    [x, y] = meshgrid(0:sz-1, 0:sz-1);

    % Compute the 2D complex exponential
    % exp(2*pi*i*(u*x + v*y)/sz)
    wave = exp(2*pi*1i*(u*x/sz + v*y/sz));

    % Plot the real part, imaginary part, and magnitude
    subplot(1, 3, 1);
    imagesc(real(wave));
    axis image; colormap gray; colorbar;
    title(['Real part (u=', num2str(u), ', v=', num2str(v), ')']);

    subplot(1, 3, 2);
    imagesc(imag(wave));
    axis image; colormap gray; colorbar;
    title(['Imaginary part (u=', num2str(u), ', v=', num2str(v), ')']);

    subplot(1, 3, 3);
    imagesc(abs(wave));
    axis image; colormap gray; colorbar;
    title(['Magnitude (u=', num2str(u), ', v=', num2str(v), ')']);
end

% frequency_domain_demo.m
% Demonstration of frequency domain image processing operations

% Analyze specific frequency points
points = [9,5; 5,9; 17,9; 17,121; 5,1; 125,1];
for i = 1:size(points, 1)
    figure(i)
    fftwave(points(i, 1), points(i, 2));
end

% Centering operation in DFT
figure;
fftwave(1, 65);
suptitle("u is very small, v just above sz");

figure;
fftwave(65, 127);
suptitle("u just above sz, v almost sz");

% Demonstrate linearity in the frequency domain
F = [zeros(56, 128); ones(16, 128); zeros(56, 128)];
G = F';
H = F + 2 * G;

Fhat = fft2(F);
Ghat = fft2(G);
Hhat = fft2(H);

figure
subplot(3, 3, 1); showgrey(F); title('F');
subplot(3, 3, 2); showgrey(G); title('G');
subplot(3, 3, 3); showgrey(H); title('H');
subplot(3, 3, 4); showgrey(log(1 + abs(Fhat))); title('Log of Fhat');
subplot(3, 3, 5); showgrey(log(1 + abs(Ghat))); title('Log of Ghat');
subplot(3, 3, 6); showgrey(log(1 + abs(Hhat))); title('Log of Hhat');
subplot(3, 3, 7); showgrey(log(1 + abs(fftshift(Hhat)))); title('Log centered Hhat');
subplot(3, 3, 8); showgrey(F .* G); title('F .* G');

% Multiplication and convolution in the frequency domain
figure
subplot(2, 2, 1); showgrey(F.*G); title('F.*G');
subplot(2, 2, 2); showfs(fft2(F.*G)); title('Fourier of F.*G');
subplot(2, 2, 3); showgrey(abs(ifft2(conv2(fftshift(Fhat), fftshift(Ghat), 'same'))));
title('Convolution of Fhat, Ghat and then inversed');
subplot(2, 2, 4); showfs(fftshift((1/(128*128))*conv2(fftshift(Fhat), fftshift(Ghat), 'same')));
title('Convolution of Fhat, Ghat');

% Rotation and Fourier transform
F = [zeros(60, 128); ones(8, 128); zeros(60, 128)] .* ...
    [zeros(128, 48) ones(128, 32) zeros(128, 48)];

figure
subplot(2, 3, 1); showgrey(F); title('F');
subplot(2, 3, 2); showfs(fft2(F)); title('Fourier of F');

alpha = 30;
G = rot(F, alpha);
subplot(2, 3, 3); showgrey(G); title('Rotation of 30 degrees');

Ghat = fft2(G);
subplot(2, 3, 4); showfs(Ghat); title('Fourier of rotated matrix');

Hhat = rot(fftshift(Ghat), -alpha);
subplot(2, 3, 5); showgrey(log(1 + abs(Hhat))); title('Logarithmic of Fourier rotated back');

% Magnitude and phase manipulation
img{1} = phonecalc128;
img{2} = few128;
img{3} = nallo128;
names_of_images = ["phonecalc128", "few128", "nallo128"];
a = 1e-10;

figure;
for i = 1:3  
    subplot(3, 3, i); showgrey(img{i}); title(names_of_images(i));
    subplot(3, 3, 3 + i); showgrey(pow2image(img{i}, a)); title("Changing magnitude");
    subplot(3, 3, 6 + i); showgrey(randphaseimage(img{i})); title("Randomizing phase");
end

% Gaussian filtering using FFT
variance_values = [0.1, 0.3, 1.0, 10.0, 100.0];
for idx = 1:length(variance_values)
    figure
    Gauss = gaussfft(deltafcn(128, 128), variance_values(idx));
    subplot(1,2,1); surf(Gauss);
    subplot(1,2,2); showfs(fftshift(Gauss));
    suptitle(['Variance: ', num2str(variance_values(idx))]);
end

% Gaussian filtering of images
new_variance_values = [1.0, 4.0, 16.0, 64.0, 256.0];
l = length(new_variance_values);

figure;
for i = 1:l
    Gauss = gaussfft(phonecalc128, new_variance_values(i));
    subplot(2, 3, i); showfs(fftshift(Gauss));
    title(['Variance: ', num2str(new_variance_values(i))]);
end
suptitle("phonecalc128 convolved with gauss, different variances");

figure;
for i = 1:l
    Gauss = gaussfft(few128, new_variance_values(i));
    subplot(2, 3, i); showfs(fftshift(Gauss));
    title(['Variance: ', num2str(new_variance_values(i))]);
end
suptitle("few128 convolved with gauss, different variances");

% Smoothing and noise reduction
office = office256;
add = gaussnoise(office, 16);  
sap = sapnoise(office, 0.1, 255);

images = {office, add, sap};
names_of_images = ["office256", "gaussnoise", "sapnoise"];

figure;
for i = 1:3
    subplot(1,3,i); showgrey(images{i}); title(names_of_images(i));
end
suptitle("Three images, increasing noise");

% Gaussian smoothing
variances = [0.1, 1, 10];
figure;
for i = 1:3
    subplot(1,3,i); showgrey(gaussfft(add, variances(i)));
    title(['Variance: ', num2str(variances(i))]);
end
suptitle("Add with gaussian filter, different variances");

% Median filter
window_sizes = [5, 10, 15];
figure;
for i = 1:3
    subplot(1,3,i); showgrey(medfilt(add, window_sizes(i)));
    title(['Window size: ', num2str(window_sizes(i))]);
end
suptitle("Add with median filter, different window sizes");

% Ideal low-pass filter
cut_off_freq = [0.01, 0.1, 0.5];
figure;
for i = 1:3
    subplot(1,3,i); showgrey(ideal(add, cut_off_freq(i)));
    title(['Cut-off freq: ', num2str(cut_off_freq(i))]);
end
suptitle("Add with ideal low-pass filter, different cut-off freq");

% Repeat for sap noise
figure;
for i = 1:3
    subplot(1,3,i); showgrey(gaussfft(sap, variances(i)));
    title(['Variance: ', num2str(variances(i))]);
end
suptitle("Sap with gaussian filter, different variances");

figure;
for i = 1:3
    subplot(1,3,i); showgrey(medfilt(sap, window_sizes(i)));
    title(['Window size: ', num2str(window_sizes(i))]);
end
suptitle("Sap with median filter, different window sizes");

figure;
for i = 1:3
    subplot(1,3,i); showgrey(ideal(sap, cut_off_freq(i)));
    title(['Cut-off freq: ', num2str(cut_off_freq(i))]);
end
suptitle("Sap with ideal low-pass filter, different cut-off freq");

% Smoothing and subsampling
img = phonecalc256;
smooth_gauss = img;
smooth_ideal_lp = img;

figure;
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
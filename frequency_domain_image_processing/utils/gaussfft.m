function Gauss = gaussfft(pic, t)
%GAUSSFFT Applies a Gaussian filter in the frequency domain.
%   Gauss = gaussfft(pic, t) convolves the image 'pic' with a Gaussian
%   filter of variance 't' using FFT.

    [row, col] = size(pic);

    % Create axis values
    x = -(row/2):(row/2)-1;
    y = -(col/2):(col/2)-1;

    % Create meshgrid
    [X, Y] = meshgrid(x, y);

    % Create Gaussian filter
    G = (1/(2 * pi * t)) * exp(-(X.^2 + Y.^2) / (2 * t));

    % Fourier transforms
    Pic_hat = fft2(pic);
    Ghat = fft2(fftshift(G));

    % Multiply and inverse FFT
    Gauss = ifft2(Pic_hat .* Ghat);
end
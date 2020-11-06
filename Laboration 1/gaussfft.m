function Gauss = gaussfft(pic, t)
    
    % Gives us the length of the rows
    row = size(pic, 1);
    col = size(pic, 2);
    
    %Creates the axis values
    x = -(row/2) : (row/2) -1;
    y = -(col/2) : (col/2) -1;

    %Creates the grid 
    [X,Y] = meshgrid(x,y);
    
    %Creating the Gauss filter (note that it is element wise)
    G = (1/(2 * pi * t)) * exp( -( X .* X + Y .* Y )/(2*t));
    
    %Fourier of pic and G (also, Pic_hat is already centered whilst Ghat is not)
    Pic_hat = fft2(pic);
    Ghat = fft2(fftshift(G));
    
    %Multiply these two together and inverse
    Gauss = ifft2(Pic_hat.*Ghat);
end
function F = fftwave(u, v, sz)

  %Changed this to 1 because it looked odd...
  if (nargin <= 1) 
    error('Requires at least two input arguments.') 
  end
  if (nargin == 2) 
    sz = 128; 
  end
  
  %Creating the fourier power spectrum with a 1 at the chosen point
  Fhat = zeros(sz);
  Fhat(u, v) = 1;
  
  %Doing the 2D Inv. Fourier Transform and also getting greyscale levels
  %The greyscale levels are done by reshaping the Inverse Matrix into a
  %coloumn vector and taking the maximum absolute value found in that
  %vector
  F = ifft2(Fhat);
  Fabsmax = max(abs(F(:)));
  
  %This plots the powerspectrum which is going to be all zeroes except for
  %the point chosen.
  subplot(3, 2, 1);
  showgrey(Fhat);
  title(sprintf('Fhat: (u, v) = (%d, %d)', u, v))
  
  % This is the centering operation of the power spectrum giving it its
  % center in the middle of the plot and the range pi to -pi both x and y
  % wise
  if (u <= sz/2)
    uc = u - 1;
  else
    uc = u - 1 - sz;
  end
  
  if (v <= sz/2)
    vc = v - 1;
  else
    vc = v - 1 - sz;
  end
  
  %Adjusting the centered frequencies to the amount of pixels 
  sampled_uc = (2*pi * uc) / sz;
  sampled_vc = (2*pi * vc) / sz;
  
  %Equation to calculate 
  wavelength = 1/sqrt(power(sampled_uc, 2) + power(sampled_vc, 2));   
  
  %Equation to calculate amplitude
  amplitude = max(abs(Fhat(:))) / sz ;

  %This plots the centered power spectrum
  subplot(3, 2, 2);
  showgrey(fftshift(Fhat));
  title(sprintf('centered Fhat: (uc, vc) = (%d, %d)', uc, vc))
  
  %Plotting the REAL part of the spatial sinewave
  subplot(3, 2, 3);
  showgrey(real(F), 64, -Fabsmax, Fabsmax);
  title('real(F)')
  
  %Plotting the IMAGINARY part of the spatial sinewave
  subplot(3, 2, 4);
  showgrey(imag(F), 64, -Fabsmax, Fabsmax);
  title('imag(F)')
  
  %Plotting the AMPLITUDE of the spatial sinewave
  %Notice how the quantization forces the plot to always be max intensity
  %in all pixels
  subplot(3, 2, 5);
  showgrey(abs(F), 64, -Fabsmax, Fabsmax);
  title(sprintf('abs(F) (amplitude %f)', amplitude))
  
  %Plotting the DIRECTION of the spatial sinewave
  subplot(3, 2, 6);
  showgrey(angle(F), 64, -pi, pi);
  title(sprintf('angle(F) (wavelength %f)', wavelength))
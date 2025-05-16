function pixels = Lv(inpic, shape)
% LV Computes the squared gradient magnitude of an image using Sobel operators.
%   pixels = Lv(inpic, shape)
%   - inpic: input image
%   - shape: convolution shape ('same', etc.)

    if nargin < 2
        shape = 'same';
    end

    % Sobel operators
    deltax = [1, 0, -1; 2, 0, -2; 1, 0, -1];
    deltay = [1, 2, 1; 0, 0, 0; -1, -2, -1];

    % Compute gradients
    Lx = filter2(deltax, inpic, shape);
    Ly = filter2(deltay, inpic, shape);

    % Squared gradient magnitude
    pixels = Lx.^2 + Ly.^2;
end
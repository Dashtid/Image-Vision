function Lvv = Lvvtilde(image, shape)
% LVVTILDE Computes the second directional derivative (Lvv) of an image.
%   Lvv = Lvvtilde(image, shape)
%   - image: input image
%   - shape: convolution shape ('same', etc.)

    if nargin < 2
        shape = 'same';
    end

    % First order derivatives
    dx = padarray([1/2, 0, -1/2], [2, 1], 0, 'both');
    dy = padarray([1/2, 0, -1/2]', [1, 2], 0, 'both');

    % Second order derivatives
    dxx = padarray([1, -2, 1], [2, 1], 0, 'both');
    dyy = padarray([1, -2, 1]', [1, 2], 0, 'both');
    dxy = conv2([1/2, 0, -1/2], [1/2, 0, -1/2]', 'same');

    % Compute derivatives
    Lx = conv2(image, dx, shape);
    Ly = conv2(image, dy, shape);
    Lxx = conv2(image, dxx, shape);
    Lxy = conv2(image, dxy, shape);
    Lyy = conv2(image, dyy, shape);

    % Second directional derivative
    Lvv = (Lx .^ 2) .* Lxx + 2 * (Lx .* Ly .* Lxy) + (Ly .^ 2) .* Lyy;
end

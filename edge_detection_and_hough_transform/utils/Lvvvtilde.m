function Lvvv = Lvvvtilde(image, shape)
% LVVVTILDE Computes the third directional derivative (Lvvv) of an image.
%   Lvvv = Lvvvtilde(image, shape)
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

    % Third order derivatives
    dxxy = conv2(dxx, dy, 'same');
    dxyy = conv2(dx, dyy, 'same');
    dxxx = conv2(dx, dxx, 'same');
    dyyy = conv2(dy, dyy, 'same');

    % Compute derivatives
    Lx = conv2(image, dx, shape);
    Ly = conv2(image, dy, shape);
    Lxxy = conv2(image, dxxy, shape);
    Lxyy = conv2(image, dxyy, shape);
    Lxxx = conv2(image, dxxx, shape);
    Lyyy = conv2(image, dyyy, shape);

    % Third directional derivative
    Lvvv = (Lx .^ 3) .* Lxxx + 3 * (Lx .^ 2) .* (Ly .* Lxxy) + ...
           3 * Lx .* (Ly .^ 2) .* Lxyy + (Ly .^ 3) .* Lyyy;
end
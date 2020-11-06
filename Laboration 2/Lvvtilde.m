function Lvv = Lvvtilde(image, shape)

% Makes sure the shape is set to 'same'
if (nargin < 2)
shape = 'same';
end

% Difference approximations of first order derivative
dx = padarray([1/2, 0, -1/2], [2, 1], 0, 'both');     
dy = padarray([1/2, 0, -1/2]', [1, 2], 0, 'both');  

% Difference approximations of second order derivative
dxx = padarray([1, -2, 1], [2, 1], 0, 'both');   
dyy = padarray([1, -2, 1]', [1, 2], 0, 'both');


dxy = conv2([1/2, 0, -1/2], [1/2, 0, -1/2]', 'same');        

% Calculations
Lx = conv2(image, dx,  shape);
Ly = conv2(image, dy,  shape);
Lxx = conv2(image, dxx, shape);
Lxy = conv2(image, dxy, shape);
Lyy = conv2(image, dyy, shape);
    
% Done instead of having to devide by the gradient magnitude
Lvv = (Lx .^ 2) .* Lxx + 2*(Lx .* (Ly .* Lxy)) + (Ly .^ 2) .* Lyy;
    
end

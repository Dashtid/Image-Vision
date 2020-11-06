function Lvvv = Lvvvtilde(image, shape)

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

% This one is going to be zero
dxy = conv2([1/2, 0, -1/2], [1/2, 0, -1/2]', 'same'); 

% The corresponding masks through concatenation
dxxy = conv2(dxx, dy, 'same');       
dxyy = conv2(dx, dyy, 'same');       
dxxx = conv2(dx, dxx, 'same');     
dyyy = conv2(dy, dyy, 'same');

% Calculations
Lx = conv2(image, dx, shape);
Ly = conv2(image, dy, shape);
Lxxy = conv2(image, dxxy, shape);
Lxyy = conv2(image, dxyy, shape);
Lxxx = conv2(image, dxxx, shape);
Lyyy = conv2(image, dyyy, shape);
    
% Done instead of having to devide by the gradient magnitude
Lvvv = ((Lx .^ 3) .* Lxxx) + 3*((Lx .^ 2) .* (Ly.*Lxxy)) + 3*(Lx .* ((Ly .^ 2) .* Lxyy)) + ((Ly .^ 3) .* Lyyy);
    
end
function pixels = Lv(inpic, shape)

% Makes sure the shape is set to 'same'
if (nargin < 2)
shape = 'same';
end

% Sobel Difference Operators
deltax = [1, 0, -1; 2, 0, -2; 1, 0, -1];
deltay = [1, 2, 1; 0, 0, 0; -1, -2, -1];

% Calculating the Sobel matrixes
Lx = filter2(deltax, inpic, shape);
Ly = filter2(deltay, inpic, shape);

%Getting the magnitude matrix
pixels = Lx.^2 + Ly.^2;
function [segmentation, centers, count] = kmeans_segm(img, K, L, seed, threshold)

% ------------------ K-MEANS ALGORITHM ------------------ %

% Let X be a set of pixels and V be a set of K cluster centers in 3D (R,G,B).
% 1. Randomly initialize the K cluster centers
% 2. Compute all distances between pixels and cluster centers
% 3. Iterate L times
% 4. Assign each pixel to the cluster center for which the distance is min
% 5. Recompute each cluster center by taking the mean of all pixels assigned to it
% 6. Recompute all distances between pixels and cluster centers

% ------------------------------------------------------- %


difference = 5;
count = 0;

% Let X be a set of pixels and V be a set of K cluster centers in 3D (R,G,B)
img = double(imresize(img, 1)); 
dim = ndims(img);

if dim == 3
    [img_x, img_y, ~] = size(img);
    X = reshape(img, img_x * img_y, 3);
else
    [img_x, ~] = size(img);
    img_y = 1;
    X = img;
end

%1. Randomly initialize the K clusters centers
RGB_MIN = int16(min(X));
RGB_MAX = int16(max(X));

% Randomizing colors
V_1 = randi([RGB_MIN(1), RGB_MAX(1)], K, 1); 
V_2 = randi([RGB_MIN(2), RGB_MAX(2)], K, 1);
V_3 = randi([RGB_MIN(3), RGB_MAX(3)], K, 1);

% Combining into RGB
V = [V_1, V_2, V_3]; 

% 2. Compute all distances between pixels and cluster centers
distance = pdist2(X, V);

while (difference > threshold)
    
    % 3. Iterate L times
    for i = 1:L
        
        % 4. Assign each pixel to the cluster center for which the distance is min
        Vtemp = double(zeros(K, 3));
        count = double(zeros(K, 1));
        
        for idx = 1:img_x * img_y
            kminimum(idx) = 1;
            leastdistance = distance(idx, 1);       
            for k = 2:K
                if (distance(idx, k) < leastdistance)
                    leastdistance = distance(idx, k);
                    kminimum(idx) = k;
                end
            end
            Vtemp(kminimum(idx), 1) = Vtemp(kminimum(idx), 1) + X(idx, 1);
            Vtemp(kminimum(idx), 2) = Vtemp(kminimum(idx), 2) + X(idx, 2);
            Vtemp(kminimum(idx), 3) = Vtemp(kminimum(idx), 3) + X(idx, 3);
            count(kminimum(idx)) = count(kminimum(idx)) + 1;
        end
        
        % 5. Recompute each cluster center by taking the mean of all pixels assigned to it
        for k = 1:K
            if (count(k) > 0)
                V(k, 1) = Vtemp(k, 1) ./ count(k);
                V(k, 2) = Vtemp(k, 2) ./ count(k);
                V(k, 3) = Vtemp(k, 3) ./ count(k);
            end
        end
        
        % 6. Recompute all distances between pixels and cluster centers
        distance = pdist2(X,V);
    end
end

size(kminimum)
Xnew = zeros(img_x*img_y, 1);

for idx = 1:img_x*img_y
    Xnew(idx) = kminimum(idx);
end

segmentation = uint8(reshape(Xnew, img_x, img_y, 1));
centers = V;

end


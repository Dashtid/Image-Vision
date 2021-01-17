function [segmentation, centers, counter] = kmeans_segm(img, K, L, seed, UNTIL_CONV, threshold)
%IDEA: Let X be a set of pixels and V be a set of K cluster centers in 3D (R,G,B).
    %1. Randomly initialize the K cluster centers
    %2. Compute all distances between pixels and cluster centers
    %3. Iterate L times
    %4. Assign each pixel to the cluster center for which the distance is min
    %5. Recompute each cluster center by taking the mean of all pixels assigned to it
    %6. Recompute all distances between pixels and cluster centers
%----------------------------------------------------------------

diff = 10;
counter = 0;

%Let X be a set of pixels and V be a set of K cluster centers in 3D (R,G,B)
img = double(imresize(img,1)); dim = ndims(img);

if dim == 3
    [img_x, img_y, rgb] = size(img);
    X = reshape(img, img_x*img_y, 3);
else
    [img_x, rgb] = size(img);
    img_y = 1;
    X = img;
end

%1. Randomly initialize the K clusters centers
RGB_min = int16(min(X));
RBX_max = int16(max(X));

%Randomize for each color component
V_1 = randi([RGB_min(1), RBX_max(1)], K, 1); 
V_2 = randi([RGB_min(2), RBX_max(2)], K, 1);
V_3 = randi([RGB_min(3), RBX_max(3)], K, 1);

%We combine the components into the RGB
V = [V_1, V_2, V_3]; 

%2. Compute all distances between pixels and cluster centers
distance = pdist2(X, V);

%3. Iterate L times if ERHAN is TRUE, otherwise until convergence
if UNTIL_CONV == true
    while (diff > threshold)
        %4. Assign each pixel to the cluster center for which the distance is min
        Vtemp = double(zeros(K, 3));
        count = double(zeros(K, 1));
        for pix=1:img_x*img_y
            kminimum(pix) = 1;
            leastdistance = distance(pix, 1);
            for k=2:K
                if (distance(pix, k) < leastdistance)
                    leastdistance = distance(pix, k);
                    kminimum(pix) = k;
                end
            end

            Vtemp(kminimum(pix), 1) = Vtemp(kminimum(pix), 1) + X(pix, 1);
            Vtemp(kminimum(pix), 2) = Vtemp(kminimum(pix), 2) + X(pix, 2);
            Vtemp(kminimum(pix), 3) = Vtemp(kminimum(pix), 3) + X(pix, 3);
            count(kminimum(pix)) = count(kminimum(pix)) + 1;
        end
        %5. Recompute each cluster center by taking the mean of all pixels assigned to it
        Vold = V;
        for k=1:K
            if (count(k) > 0)
                V(k, 1) = Vtemp(k, 1) ./ count(k);
                V(k, 2) = Vtemp(k, 2) ./ count(k);
                V(k, 3) = Vtemp(k, 3) ./ count(k);
            end
        end
        %6. Recompute all distances between pixels and cluster centers
        diff = abs(max(Vold-V));
        distance = pdist2(X,V);
        counter = counter + 1;
    end
else
    for i = 1:L
        %4. Assign each pixel to the cluster center for which the distance is min
        Vtemp = double(zeros(K, 3));
        count = double(zeros(K, 1));
        for pix=1:img_x*img_y
            kminimum(pix) = 1;
            leastdistance = distance(pix, 1);
            for k=2:K
                if (distance(pix, k) < leastdistance)
                    leastdistance = distance(pix, k);
                    kminimum(pix) = k;
                end
            end

            Vtemp(kminimum(pix), 1) = Vtemp(kminimum(pix), 1) + X(pix, 1);
            Vtemp(kminimum(pix), 2) = Vtemp(kminimum(pix), 2) + X(pix, 2);
            Vtemp(kminimum(pix), 3) = Vtemp(kminimum(pix), 3) + X(pix, 3);
            count(kminimum(pix)) = count(kminimum(pix)) + 1;
        end
        
        %5. Recompute each cluster center by taking the mean of all pixels assigned to it
        for k=1:K
            if (count(k) > 0)
                V(k, 1) = Vtemp(k, 1) ./ count(k);
                V(k, 2) = Vtemp(k, 2) ./ count(k);
                V(k, 3) = Vtemp(k, 3) ./ count(k);
            end
        end
        %6. Recompute all distances between pixels and cluster centers
        distance = pdist2(X,V);
    end
end

size(kminimum)
Xnew = zeros(img_x*img_y, 1);
for pix=1:img_x*img_y
    Xnew(pix) = kminimum(pix);
end
segmentation = uint8(reshape(Xnew, img_x, img_y, 1));
centers = V;
end


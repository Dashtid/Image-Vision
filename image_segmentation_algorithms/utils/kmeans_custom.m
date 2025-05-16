function [segmentation, centers] = kmeans_custom(Im_vec, K, L, seed)

% Prepping the cluster centers and setting a threshold
centers = zeros(K, 3);
threshold = 2;

% Fetching centers from image
idx = randperm(size(Im_vec, 1), K);
for i = 1 : K
    centers(i, :) = Im_vec(idx(i), :);
end

% Computing the distance from pixels to centroids
Distance_vec = pdist2(centers, Im_vec, 'euclidean');

for i = 1 : L
    [~, idx] = min(Distance_vec); 
    
    % Updating
    for j = 1 : K
        num_idx = find(idx == j);
        if size(num_idx, 2) < threshold
            centers(j, :) = rand(1, 3);
        else
            centers(j, :) = double(mean(Im_vec(num_idx, :)));
        end
    end
    Distance_vec = pdist2(centers, Im_vec, 'euclidean');
end

% Creating the output
[~, idx] = min(Distance_vec);
segmentation = idx;
function [segmentation, centers] = kmeans_mix(I_vec, K, L, seed)
clus_centers = zeros(K, 3);
nthreshold = 2;

%Choose cluster centers from img pixels
idx = randperm(size(I_vec, 1), K);
for i = 1 : K
    clus_centers(i, :) = I_vec(idx(i), :);
end

%Compute dist <=> pixels and cluster centroids
D_vec = pdist2(clus_centers, I_vec, 'euclidean');

for i = 1 : L
    [~, cen_idx] = min(D_vec);
    
    %Recompute
    for j = 1 : K
        n_idx = find(cen_idx == j);
        if size(n_idx, 2) < nthreshold
            clus_centers(j, :) = rand(1, 3);
        else
            clus_centers(j, :) = double(mean(I_vec(n_idx, :)));
        end
    end
    D_vec = pdist2(clus_centers, I_vec, 'euclidean');
end

[~, cen_idx] = min(D_vec);
segmentation = cen_idx;
centers = clus_centers;
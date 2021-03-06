function [probability] = mixture_prob (Im, K, L, mask)

seed = 1337; % Setting the seed as per usual

% Number of rows and columns
num_rows = size(Im, 1);
num_cols = size(Im, 2);

% K is gaussian components and I is pixels
Im_double = im2double(reshape(Im, num_rows * num_cols, 3));
Mask_reshaped = reshape(mask, num_rows * num_cols, 1);

Im_w_ones = Im_double(find(Mask_reshaped == 1), :);
zero_vec = zeros(size(Im_w_ones, 1), K);

% Initializing K
[segmentation, centers] = kmeans_custom(Im_w_ones, K, L, seed);
covariance = cell(K, 1);
covariance(:) = {rand * eye(3)};

temp_vec = zeros(1, K);
for i = 1 : K
    temp_vec(i) = sum(segmentation == i) / size(segmentation, 1);
end

g1 = zeros(num_rows * num_cols, K);

% Iterating through L
for i = 1 : L
    % Computing prob. using mask 
    for k = 1 : K
        k_mean = centers(k, :);
        k_cov = covariance{k};
        difference = bsxfun(@minus, Im_w_ones, k_mean);
        zero_vec(:, k) = 1 / sqrt(det(k_cov) * (2 * pi) ^ 3) * exp(-0.5 * sum((difference * inv(k_cov) .* difference), 2));
    end
    
    p = bsxfun(@times, zero_vec, temp_vec);
    norm = sum(p, 2);
    p = bsxfun(@rdivide, p, norm);
    
    % Updating all components to achieve maximization
    temp_vec = sum(p, 1) / size(p, 1);
    for k = 1 : K
        tot = sum(p(:, k), 1);
        centers(k, :) = p(:, k)' * Im_w_ones / tot;
        difference = bsxfun(@minus, Im_w_ones, centers(k, :));
        covariance{k} = (difference' * bsxfun(@times, difference, p(:, k))) / tot;
    end
end

% Probabilities for all pixels in Im
for k = 1 : K
    k_mean = centers(k, :);
    k_cov = covariance{k};
    difference = bsxfun(@minus, Im_double, k_mean);
    g1(:, k) = 1 / sqrt(det(k_cov) * (2 * pi)^3) * exp(-1/2 * sum((difference * inv(k_cov) .* difference), 2));
end

prob_prior = sum(bsxfun(@times, g1, temp_vec), 2);
probability = reshape(prob_prior, num_rows, num_cols, 1);

end

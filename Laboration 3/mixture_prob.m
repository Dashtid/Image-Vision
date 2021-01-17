function [prob] = mixture_prob (img, K, L, mask)
%Use mask to identify pixels from img, used to estimate a mix of K Gaussian components

%Img no. rows and cols
n_rows = size(img, 1);
n_cols = size(img, 2);

%1. Let I be a set of pixels and V a set of K Guassian comp in 3D (R,G,B)
I_vec = im2double(reshape(img, n_rows * n_cols, 3));
M_vec = reshape(mask, n_rows * n_cols, 1);

I_vec_ones = I_vec(find(M_vec == 1), :);
g = zeros(size(I_vec_ones, 1), K);

%2. Randomly initialize the K components using masked pixels
seed = 4321;
[segmentation, centers] = kmeans_mix(I_vec_ones, K, L, seed);
cov = cell(K, 1);
cov(:) = {rand * eye(3)};

w = zeros(1, K);
for i = 1 : K
    w(i) = sum(segmentation == i) / size(segmentation, 1);
end

g1 = zeros(n_rows * n_cols, K);

%3. Iterate L times - run Expectation-Maximation for each loop
for i = 1 : L
    %4. Expectation: Compute probabilities P_ik using masked pixels
    for k = 1 : K
        mean_k = centers(k, :);
        cov_k = cov{k};
        diff = bsxfun(@minus, I_vec_ones, mean_k);
        g(:, k) = 1 / sqrt(det(cov_k) * (2 * pi)^3) * exp(-0.5 * sum((diff * inv(cov_k) .* diff), 2));
    end
    
    p = bsxfun(@times, g, w);
    norm = sum(p, 2);
    p = bsxfun(@rdivide, p, norm);
    
    %5. Maximization: Update weights, means and covariances using masked pixels
    w = sum(p, 1) / size(p, 1);
    for k = 1 : K
        tot = sum(p(:, k), 1);
        centers(k, :) = p(:, k)' * I_vec_ones / tot;
        diff = bsxfun(@minus, I_vec_ones, centers(k, :));
        cov{k} = (diff' * bsxfun(@times, diff, p(:, k))) / tot;
    end
end

%6. Compute probabilities p(c_i) in Eq.(3) for all pixels I
for k = 1 : K
    mean_k = centers(k, :);
    cov_k = cov{k};
    diff = bsxfun(@minus, I_vec, mean_k);
    g1(:, k) = 1 / sqrt(det(cov_k) * (2 * pi)^3) * exp(-1/2 * sum((diff * inv(cov_k) .* diff), 2));
end

prob_pre = sum(bsxfun(@times, g1, w), 2);
prob = reshape(prob_pre, n_rows, n_cols, 1);

end

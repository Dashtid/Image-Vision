function Im_updated = mean_segm(Im, segmentation)

N = max(max(segmentation));
[h, w, c] = size(Im);
Im_c = single(reshape(Im, [h * w, c]));
seg_reshape = reshape(segmentation, [h * w, 1]);
cols = zeros(N, c);
nums = zeros(N, 1);

for i = 1 : h * w
    seg_reshape_vec = seg_reshape(i);
    cols(seg_reshape_vec, :) = cols(seg_reshape_vec, :) + Im_c(i, :);
    nums(seg_reshape_vec) = nums(seg_reshape_vec) + 1;
end

cols = bsxfun(@rdivide, cols, nums);
Im_updated = uint8(reshape(cols(seg_reshape, :), [h, w, c]));

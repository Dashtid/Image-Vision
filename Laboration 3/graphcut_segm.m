function [ segm, prior ] = graphcut_segm(I, area, K, alpha, sigma)

[h,w,~] = size(I);
dw = area(3) - area(1) + 1;
dh = area(4) - area(2) + 1;
mask = uint8([zeros(area(2)-1,w); zeros(dh,area(1)-1), ones(dh,dw), zeros(dh,w-area(3)); zeros(h-area(4),w)]);

grey = single(rgb2gray(I));
h = fspecial('gaussian', [7,7], 0.5);
grey = imfilter(grey, h);
h = fspecial('sobel');
d_x = imfilter(grey, h/4);
d_y = imfilter(grey, h/4');
gradient = sqrt(d_x.^2 + d_y.^2);
edge = (alpha*sigma)*ones(size(grey)) ./ (gradient + sigma);

tic
for l=1:3

    fprintf('Find Gaussian mixture models...\n');
    fprob = mixture_prob(I, K, 10, mask);
    bprob = mixture_prob(I, K, 10, 1-mask);
    prior = reshape(fprob ./ (fprob + bprob), size(I,1), size(I,2), 1);
    toc

    fprintf('Find minimum cut...\n');
    [u, ~, ~] = cmf_cut(prior, edge);
    mask = uint8(u>0.5);
    toc

end

segm = int16(u>0.5) + 1;


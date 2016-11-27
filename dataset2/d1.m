clc;
clear all;
imset = imageSet('./e1');
seg_d = zeros(124,124,imset.Count);
seg_e = zeros(124,124,imset.Count);
area_e = zeros(1,imset.Count);
area_d = zeros(1,imset.Count);
for i=1:imset.Count
    x = read(imset,i);
    x = imresize(x,[124 124]);
%     x = imread('./e1/e1_1.jpg');
    x = rgb2gray(x);
    se = strel('disk',5);
    op = imopen(x,se);
    opcl = imclose(op,se);
    cl = imclose(x,se);
    clop = imopen(cl,se);
    occo = (opcl + clop)/2;
    occo = imgaussfilt(occo);
    % imshow(occo);
    h = imhist(occo);   
    th = sum(h)/255;
    % th = uint8(th);
    level = th / 255;
    bw = im2bw(occo,level);
    bw = imopen(bw,se);
    
    cc = bwconncomp(1-bw);
    surface_cc = cellfun(@numel,cc.PixelIdxList);
    
    ch = bwconvhull(1-bw,'objects',8);
    ch_cc = bwconncomp(ch);
    surface_ch = cellfun(@numel,ch_cc.PixelIdxList);
    ratio_c = double(surface_cc) / double(surface_ch);
    e_bw = imerode(1-bw,se);
    e_bw_cc = bwconncomp(e_bw);
    surface_e_cc = cellfun(@numel,e_bw_cc.PixelIdxList);
    ratio_e = double(surface_e_cc) / double(surface_cc);
    
    while ratio_e > ratio_c;
        e_bw = imerode(e_bw,se);
        e_bw_cc = bwconncomp(e_bw);
        surface_e_cc = cellfun(@numel,e_bw_cc.PixelIdxList);
        ratio_e = double(surface_e_cc) / double(surface_cc);
    end
    
    
    d_bw = imdilate(1-bw,se);
    d_bw_cc = bwconncomp(d_bw);
    surface_d_cc = cellfun(@numel,d_bw_cc.PixelIdxList);
    ratio_d = double(surface_d_cc) / double(surface_cc);
    
    while ratio_d < 2 - ratio_c;
        d_bw = imerode(d_bw,se);
        d_bw_cc = bwconncomp(d_bw);
        surface_d_cc = cellfun(@numel,d_bw_cc.PixelIdxList);
        ratio_d = double(surface_d_cc) / double(surface_cc);
    end
    
    seg_e(:,:,i) = e_bw;
    seg_d(:,:,i) = d_bw;
    area_e(1,i) = surface_e_cc;
    area_d(1,i) = surface_d_cc;
%     figure;
%     subplot(2,2,1);imshow(bw);
%     subplot(2,2,2);imshow(ch);
%     subplot(2,2,3);imshow(e_bw);
%     subplot(2,2,4);imshow(d_bw);
end
[val_maxd idx_maxd] = max(area_d);
final_d = seg_d(:,:,idx_maxd);
B_d = bwboundaries(final_d);
imshow(bw);
hold on
for k = 1:length(B_d)
   boundary = B_d{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
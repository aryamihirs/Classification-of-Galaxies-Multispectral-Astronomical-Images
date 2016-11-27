function MaskedImg = segment(str,im)
    imset = imageSet(str);
    seg_d = zeros(124,124,imset.Count);
    seg_e = zeros(124,124,imset.Count);
    area_e = zeros(1,imset.Count);
    area_d = zeros(1,imset.Count);
    gravity_c = [[62 63] [62 65] [66 62] [63 63]];
    for i=1:imset.Count
        x = read(imset,i);
%         x = imread('./s1/s1_1.jpg');
        x = imresize(x,[124 124]);   
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
        th = 0;
        for j = 1:256
            th = th + (j-1)*h(j);
        end
        th = th / (124*124);
        % th = uint8(th);
        level = th / 255;
        bw = im2bw(occo,level);
    %     bw = im2bw(occo);
        bw = imopen(bw,se);
    
        cc = bwconncomp(1-bw);
        surface_cc = cellfun(@numel,cc.PixelIdxList);
    
        ch = bwconvhull(1-bw,'objects',8);
        ch_cc = bwconncomp(ch);
        surface_ch = cellfun(@numel,ch_cc.PixelIdxList);
        ratio_c = double(max(surface_cc)) / double(max(surface_ch));
        e_bw = imerode(1-bw,se);
        e_bw_cc = bwconncomp(e_bw);
        surface_e_cc = cellfun(@numel,e_bw_cc.PixelIdxList);
        ratio_e = double(max(surface_e_cc)) / double(max(surface_cc));
    
        while ratio_e > ratio_c;
            e_bw = imerode(e_bw,se);
            e_bw_cc = bwconncomp(e_bw);
            surface_e_cc = cellfun(@numel,e_bw_cc.PixelIdxList);
            ratio_e = double(max(surface_e_cc)) / double(max(surface_cc));
        end
    
    
        d_bw = imdilate(1-bw,se);
        d_bw_cc = bwconncomp(d_bw);
        surface_d_cc = cellfun(@numel,d_bw_cc.PixelIdxList);    
        ratio_d = double(max(surface_d_cc)) / double(max(surface_cc));
    
        while ratio_d < 2 - ratio_c;
            d_bw = imdilate(d_bw,se);
            d_bw_cc = bwconncomp(d_bw);
            surface_d_cc = cellfun(@numel,d_bw_cc.PixelIdxList);
            ratio_d = double(max(surface_d_cc)) / double(max(surface_cc));
        end
        
        MinArNumPixels = cellfun(@numel,d_bw_cc.PixelIdxList);  
        [biggest,idx] = min(MinArNumPixels);
        d_bw(d_bw_cc.PixelIdxList{idx}) = 0;
    
        seg_e(:,:,i) = e_bw;
        seg_d(:,:,i) = d_bw;
        area_e(i) = max(surface_e_cc);
        area_d(i) = max(surface_d_cc);
    
    %     figure;
    %     subplot(2,2,1);imshow(bw);
    %     subplot(2,2,2);imshow(ch);
    %     subplot(2,2,3);imshow(e_bw);  
    %     subplot(2,2,4);imshow(d_bw);
    end
    [val_maxd idx_maxd] = max(area_d);
    final_d = seg_d(:,:,idx_maxd);
    B_d = bwboundaries(final_d);
%     temp = imread('../dataset2/s1/s1_1.jpg');
    im = imresize(im,[124 124])
    sz = size(im);
    for k = 1:sz(1)
        for l=1:sz(2)
            if  final_d(k,l) == 1;
                MaskedImg(k,l) = im(k,l);
            else
                MaskedImg(k,l) = 0;
            end
        end
    end
    imshow(im);
    hold on
    for k = 1:length(B_d)
       boundary = B_d{k};
       plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 1)
    end
end
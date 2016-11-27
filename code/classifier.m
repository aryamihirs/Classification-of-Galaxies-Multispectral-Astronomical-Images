function op = classifier(mask, image)
I1 = imread('gal11.jpg');
I1 = medfilt2(I1);
SE = strel('disk',5,5);
i1 = I1 - imopen(I1,SE);
I1 = imbinarize(i1);
BW2 = bwareaopen(I1,)
imshow(i1);






function op = classifier(maskedImage)
I1 = medfilt2(maskedImage);
SE = strel('disk',5,5);
i1 = I1 - imopen(I1,SE);
I1 = imbinarize(i1);
BW2 = bwareaopen(I1,20);

imshow(BW2);






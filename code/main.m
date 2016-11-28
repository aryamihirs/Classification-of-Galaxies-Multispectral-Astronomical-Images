clc;
clear all;

str_s1 = '../dataset2/s1';
im_s1 = imread('../dataset2/s1/s1_1.jpg');
str_s2 = '../dataset2/s2';
im_s2 = imread('../dataset2/s2/s2_1.jpg');
str_e1 = '../dataset2/e1';
im_e1 = imread('../dataset2/e1/e1_1.jpg');
str_e2 = '../dataset2/e2';
im_e2 = imread('../dataset2/e2/e2_1.jpg');

[MaskedIm_s1,ecc_s1] = segment(str_s1,im_s1);
% MaskedIm_s2 = segment(str_s2,im_s2);
[MaskedIm_e1,ecc_e1] = segment(str_e1,im_e1);
[MaskedIm_e2,ecc_e2] = segment(str_e2,im_e2);

classifier(MaskedIm_s1,ecc_s1);
% classifier(MaskedIm_s2);
classifier(MaskedIm_e1,ecc_e1);
classifier(MaskedIm_e2,ecc_e2);
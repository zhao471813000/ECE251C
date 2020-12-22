clear all
close all
%input test image
im=imread('vase.jpg');
figure
imshow(im);
title('Original image');
%generate noisy image
rho=3;
im=double(im)/256;
s=std(im(:));
sig=s/rho;
im_n=im+sig*randn(size(im));
%input ground truth
im1=imread('vase_ed.bmp');
im1=im2bw(im1);
[r c]=size(im_n);
figure
imshow(im_n);
title('Noisy image');
figure
imshow(im1);
title('Ground truth');
%% apply edge detection using using convetional method
im_p=edge(im_n,'Prewitt');
figure
imshow(im_p);
title('Prewitt');
im_s=edge(im_n,'Sobel');
figure
imshow(im_s);
title('Sobel');
im_c=edge(im_n,'Canny',[0.1,0.25]);
figure
imshow(im_c);
title('Canny');
%% Calculate the data for Comparison
%1.Prewitt
[TP_p,FP_p,TN_p,FN_p,TPR_p,FPR_p,TNR_p,ACC_p]=compare(im_p,im1);
%2.Sobel
[TP_s,FP_s,TN_s,FN_s,TPR_s,FPR_s,TNR_s,ACC_s]=compare(im_s,im1);
%3.Canny
[TP_c,FP_c,TN_c,FN_c,TPR_c,FPR_c,TNR_c,ACC_c]=compare(im_c,im1);
%% Apply edge detection using contourlet transform
%contourlet_toolbox used, provided by Minh N. Do
%set parameters
pfilt='9-7';
dfilt='pkva';
level=[0,0,4,4,5];
th=3;

% contourlet denoise
y=pdfbdec(im_n,pfilt,dfilt,level);
[c,s]=pdfb2vec(y);
var_n=pdfb_nest(size(im,1),size(im,2),pfilt,dfilt,level);
th_c=th*sig*sqrt(var_n);
scale=s(end,1);
scale_size=sum(prod(s(find(s(:,1)==scale),3:4),2));
th_c(end-scale_size+1:end)=4/3*th_c(end-scale_size+1:end);
c=c.*(abs(c)>th_c);
%Reconstruct the denoise image
y=vec2pdfb(c,s);
im_c=pdfbrec(y,pfilt,dfilt);
%edge detection
im_c=ED(im);
figure
imshow(im_c);
title('Contourlet');
[TP_d,FP_d,TN_d,FN_d,TPR_d,FPR_d,TNR_d,ACC_d]=compare(im_c,im1);
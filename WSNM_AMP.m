clc;
close all;
clear;
cur=cd;
% parpool;
addpath(genpath(cur));
Finalpsnr=zeros(20,272);
Finalssim=zeros(20,272);
Finalimage=zeros(128,128,272);  %如果是cell  创建时候是cell（1,240），应用是Finalimage{1}，
shu=1;
noises=[0 10 20 50];

for   l=1:17 
for  SamplingRate=0.1:0.1:0.4
for   j=1:4
    noise=noises(j);
switch  l
     case 1
         filename='barbara.tif';
     case 2
         filename='boat.tif';
     case 3
         filename='house.tif';
     case 4
         filename='peppers256.tif';
     case 5
         filename='Monarch.tif';
     case 6
         filename='star.png';
     case 7
         filename='Parrots.tif';
     case 8
        filename='straw.tif'; 
     case 9
        filename='Lena512.tif';
     case 10
        filename='man.tif';
     case 11
        filename='fingerprint.tif';
     case 12
        filename='couple.tif';
     case 13
        filename='Leaves256.tif';
    case 14
        filename='hill.tif';   
    case 15
        filename='cameraman.tif';
    case 16
        filename='fly.png';
    case 17
        filename='baboon.bmp';
end
t1=clock;
imsize=128;
iters=20;
ImIn=double(imread(filename));
x0=imresize(ImIn,imsize/size(ImIn,1));
[height, width]=size(x0);
n=length(x0(:));
m=round(n*SamplingRate);
randn('state',0);
randn('seed', 0);
M=randn(m,n);
for i=1:n
    M(:,i)=M(:,i)/sqrt((sum(abs(M(:,i)).^2)));
end
y=M*x0(:);
y=y+randn(size(y))*noise;
[x_hat, psnr,ssim] = DAMP(y,x0,iters,height,width,M);
t2=clock;
time1=etime(t2,t1)

Finalpsnr(:,shu)=psnr';
Finalssim(:,shu)=ssim';
Finalimage(:,:,shu)=x_hat;

shu=shu+1;
end
end
end
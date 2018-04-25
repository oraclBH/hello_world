% clear;
% clc;
% load('wsnm_17_272_0.1_0.4_0_10_20_50_ssim.mat');
% % load('wsnm_17_272_0.1_0.4_0_10_20_50_psnr.mat');
% sj=Finalssim;
% % sj=Finalpsnr;
% %%无噪采样率 0.1~0.4
% ssim=zeros(20,68);
% SSIM=zeros(4,17);
% num=1;nun=1;
% for i=1:4:272
%    ssim(:,num)=sj(:,i);
%    num=num+1;
%  end
% 
% for i=1:17
%     for j=1:4
%         SSIM(j,i)=ssim(20,nun);
%         nun=nun+1;
%     end
% end
% x=1:17;
% plot(x,SSIM(1,:),'b-*',x,SSIM(2,:),'r-p',x,SSIM(3,:),'k-s',x,SSIM(4,:),'c-d')
% 
% legend('0.1采样率','0.2采样率','0.3采样率','0.4采样率')
% 
% a=[1,3,5,6,7,13,15,16];
% final=zeros(4,8);
% final= SSIM(:,a);






%%0.2采样率有噪10-20-50情况下

load('wsnm_17_272_0.1_0.4_0_10_20_50_psnr.mat');

sj=Finalpsnr;
%%无噪采样率 0.1~0.4
ssim=zeros(20,68);
SSIM=zeros(3,17);
num=1;nun=1;
for i=6:16:272
    for j=0:2
       ssim(:,num)=sj(:,i+j);
       num=num+1;
    end
end

for i=1:17
    for j=1:3
        SSIM(j,i)=ssim(20,nun);
        nun=nun+1;
    end
end
x=1:17;
plot(x,SSIM(1,:),'b-*',x,SSIM(2,:),'r-p',x,SSIM(3,:),'k-s')

a=[1,3,5,6,7,13,15,16];
final=zeros(3,8);
final= SSIM(:,a);








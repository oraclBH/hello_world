function output = denoise(noisy,noisy_D,sigma_hat,width,height,x)

noisy=reshape(noisy,[width,height]);                     
noisy_D=reshape(noisy_D,[width,height]);   
output=zeros(size(noisy(:),1),2);

[m,n]=size(noisy);
ni=zeros(m,n,2);
z=zeros(size(ni));
ni(:,:,1)=noisy;
ni(:,:,2)=noisy_D;

parfor i=1:2
% for i=1:2
         z(:,:,i) = WSNM_denosing( ni(:,:,i),sigma_hat,x);
end
temp1=z(:,:,1);
output(:,1)=temp1(:);
temp2=z(:,:,2) ;
output(:,2)=temp2(:) ;




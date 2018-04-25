function [x_hat ,Psnr,ssim]=DAMP(y,x,iters,height,width,M)

n=width*height;  
m=length(y);  
denoi=@(noisy,noisy_D,sigma_hat) denoise(noisy,noisy_D,sigma_hat,width,height,x);

z_t=y;
x_t=zeros(n,1);
Psnr=zeros(1,iters);
ssim=zeros(1,iters);


for i=1:iters
    
    fprintf( 'Iteration %d :\n', i);
    pseudo_data=M'*(z_t)+x_t; 
    sigma_hat=sqrt(1/m*sum(abs(z_t).^2));   
      
    fprintf('Noisy Image: nSig = %2.3f \n',sigma_hat); 
    
%     if i~=1
%     if  norm(x_t-temp)/norm(x_t)<=10^(-3)
%         break;
%     end
%     end 
    
    temp=x_t;
    eta=randn(1,n);
    
    epsilon=max(pseudo_data)/1000+eps;
    pseudo_data_D=pseudo_data+epsilon*eta';
    X=denoi(pseudo_data,pseudo_data_D,sigma_hat);  
    x_t=X(:,1);                     
    Psnr(i) = csnr(x(:)/255,x_t/255,0,0);
    x_t_tmp=reshape(x_t,height,width);
    ssim(i) = cal_ssim(x_t_tmp,x,0,0);
    fprintf('PSNR=%2.3f , SSIM=%2.7f \n',Psnr(i),ssim(i)); 
    
    div=eta*((X(:,2)-x_t)/epsilon);                                              
    z_t=y-M*(x_t)+1/m.*z_t.*div; 
end
x_hat=reshape(x_t,[height width]);

end

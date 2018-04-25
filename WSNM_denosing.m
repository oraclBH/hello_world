function  output=WSNM_denosing(noisy,sigma_hat,x)

nSig=sigma_hat/255;
N_Img=noisy/255; 


Par.nSig      =   nSig;                                 % Variance of the noise image
Par.SearchWin =   30;                                   % Non-local patch searching window
Par.delta     =   0.1;                                  % Parameter between each iter
Par.c         =   2*sqrt(2);                            % Constant num for the weight vector
Par.Innerloop =   2;                                    % InnerLoop Num of between re-blockmatching   ??
Par.ReWeiIter =   3;
if nSig<=20/255
    Par.patsize       =   6;                            % Patch size
    Par.patnum        =   70;                           % Initial Non-local Patch number
    Par.Iter          =   8;                            % total iter numbers
    Par.lamada        =   0.54;                         % Noise estimete parameter
    Par.p=1;
elseif nSig <= 40/255
    Par.patsize       =   6;
    Par.patnum        =   90;
    Par.Iter          =   12; %12
    Par.lamada        =   0.60; 
    Par.p=0.85;
elseif nSig<=60/255
    Par.patsize       =   6;
    Par.patnum        =   120;
    Par.Iter          =   16;  %16
    Par.lamada        =   0.64; 
    Par.p=0.75;
elseif nSig<=100/255
    Par.patsize       =   6;
    Par.patnum        =   140;
    Par.Iter          =  9;  %12
    Par.lamada        =   0.64; 
    Par.p=0.05;
elseif nSig<=150/255
    Par.patsize       =   6;
    Par.patnum        =   150;
    Par.Iter          =   9;   %14
    Par.lamada        =   0.66; 
    Par.p=0.05;
elseif nSig<=300/255
    Par.patsize       =  6;
    Par.patnum        =   150;
    Par.Iter          =   10;   %11
    Par.lamada        =   0.64; 
    Par.p=0.05;
else
    Par.patsize       =  6;
    Par.patnum        =   160;
    Par.Iter          =   10;  %12
    Par.lamada        =   0.66; 
    Par.p=0.05;
end
  
Par.step      =   floor((Par.patsize)/2-1);  


E_Img           = N_Img;                                                        % Estimated Image
[Height Width]  = size(E_Img);   
TotalPatNum     = (Height-Par.patsize+1)*(Width-Par.patsize+1);                 %Total Patch Number in the image
Dim             = Par.patsize*Par.patsize;  


[Neighbor_arr Num_arr Self_arr] =	NeighborIndex(N_Img, Par);                  % PreCompute the all the patch index in the searching window 
            NL_mat              =   zeros(Par.patnum,length(Num_arr));          % NL Patch index matrix
            CurPat              =	zeros( Dim, TotalPatNum );
            Sigma_arr           =   zeros( 1, TotalPatNum);            
            EPat                =   zeros( size(CurPat) );     
            W                   =   zeros( size(CurPat) );          
            
for iter = 1 : Par.Iter       
    E_Img_old           =   E_Img;
    
    
    E_Img             	=	E_Img + Par.delta*(N_Img - E_Img);
    [CurPat, Sigma_arr]	=	Im2Patch( E_Img, N_Img, Par );                      % image to patch and estimate local noise variance            
    
    if (mod(iter-1,Par.Innerloop)==0)
        Par.patnum = Par.patnum-10;                                             % Lower Noise level, less NL patches
        NL_mat  =  Block_matching(CurPat, Par, Neighbor_arr, Num_arr, Self_arr);% Caculate Non-local similar patches for each 
        if(iter==1)
            Sigma_arr = Par.nSig * ones(size(Sigma_arr));                       % First Iteration use the input noise parameter
        end
    end       

     [EPat, W]  =  PatEstimation( NL_mat, Self_arr, Sigma_arr, CurPat, Par );   % Estimate all the patches
     E_Img      =  Patch2Im( EPat, W, Par.patsize, Height, Width );    

     PSNR  = csnr(x/255,E_Img, 0, 0 );    
     
     tmp = sqrt(sum(sum((E_Img - E_Img_old).^2))/numel(E_Img));
     %fprintf( 'Iter = %2.3f, sp = %2.3f, after global constraint, PSNR = %2.2f, dif = %2.7f\n', iter, p2, PSNR, tmp);
     fprintf( 'Iter = %2.3f, PSNR = %2.2f, dif = %2.7f\n', iter, PSNR, tmp);
end


output=E_Img*255;
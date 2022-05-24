function [train_error, test_error,test_prob]= CrossValidation2(datasub)

train_error=[];
test_prob=[];
test_error=[];
    
    for cross=1:35
        %param0=rand([1,4]);
        param0=[1 1 1 1];
        fun=@(param)myfun_cross2(param,datasub,cross);
        paramf=fminunc(fun,param0); %optimal parameters for this fold
        
        sigmaAf=exp(paramf(1));
        sigmaVf=exp(paramf(2));
        cAf=paramf(3);
        cVf=paramf(4);

        x=1:5;
        muAf=x-cAf;
        muVf=x-cVf;

        PA_f=normcdf(muAf/(sigmaAf));
        PV_f=normcdf(muVf/(sigmaVf));
        sigma_AVf=sqrt((sigmaVf^2*sigmaAf^2)/(sigmaVf^2+sigmaAf^2));
        
        PAV_f=zeros(5,5);
        for a=1:5
            for v=1:5
                mu_AVf=((sigmaVf^2)/(sigmaVf^2+sigmaAf^2))*muAf(a) + ((sigmaAf^2)/(sigmaVf^2+sigmaAf^2))*muVf(v);
                PAV_f(v,a) = normcdf(mu_AVf/(sigma_AVf));
            end
        end
        

        pAVmatrix_f=[PA_f;PV_f;PAV_f];
        pAVf=[];
        N=24;

        for k=1:7
            pAVf(k,:)=binopdf(datasub(k,:),N,pAVmatrix_f(k,:));
        end

        mat_re_bi=reshape(pAVf,[35 1]);
        mat_re=reshape(pAVmatrix_f,[35 1]);
        
        prod_mat=[];
        for i=1:35
            if i ~= cross
                prod_mat=[prod_mat mat_re_bi(i)];
            else
                test_error(cross)=-log(mat_re_bi(i));%Test Error
                test_prob(cross)=mat_re(i);
            end
        end
        train_error(cross)=-log(prod(prod_mat)); %Training Error

    end

end
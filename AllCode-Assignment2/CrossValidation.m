
function [train_error, test_error,test_prob]= CrossValidation(datasub)

train_error=[];
test_prob=[];
test_error=[];
    
    for cross=1:35
        theta0=rand([1,10]); %auditory stimulus and visual  stimulus
        fun=@(theta)myfun_cross(theta,datasub,cross);
        thetaf=fminunc(fun,theta0); %optimal parameters for this fold
        
        %Training Error
        PA_f=exp(thetaf(1:5))./(exp(thetaf(1:5))+1);
        PV_f=exp(thetaf(6:10))./(exp(thetaf(6:10))+1);

        PAV_f=zeros(5,5);
        for a=1:5
            for v=1:5
                PAV_f(v,a) = (PA_f(a).*PV_f(v))./((PA_f(a).*PV_f(v))+((1-PA_f(a)).*(1-PV_f(v))));
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
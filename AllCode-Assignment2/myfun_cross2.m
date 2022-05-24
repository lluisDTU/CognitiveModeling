
function Nlog = myfun_cross2(param,datasub,cross)

N=24;
sigmaA=exp(param(1));
sigmaV=exp(param(2));
cA=param(3); 
cV=param(4); 

x=1:5;
muA=x-cA;
muV=x-cV;

PA_i=normcdf(muA/(sigmaA));
PV_i=normcdf(muV/(sigmaV));

sigma_AV=sqrt((sigmaV^2*sigmaA^2)/(sigmaV^2+sigmaA^2));


PAV_i=zeros(5,5);
for a=1:5
    for v=1:5
        %parameters for AV normal distribution --> model assumption 
        mu_AV=((sigmaV^2)/(sigmaV^2+sigmaA^2))*muA(a) + ((sigmaA^2)/(sigmaV^2+sigmaA^2))*muV(v);
        PAV_i(v,a) = normcdf(mu_AV/(sigma_AV));
    end
end

pAVmatrix=[PA_i;PV_i;PAV_i];

for k=1:7
    pAVf(k,:)=binopdf(datasub(k,:),N,pAVmatrix(k,:));
end

mat_re=reshape(pAVf,[35 1]);

prod_mat=[];
for i=1:35
    if i ~= cross
        prod_mat=[prod_mat mat_re(i)];
    end
end
   
Nlog=-log(prod(prod_mat));

end
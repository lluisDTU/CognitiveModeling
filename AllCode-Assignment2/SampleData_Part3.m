
clearvars -except AllResults
clc;

%Sample data for 5 subjects FLMP
thetaA= sort(-5.5 + (6-(-5.5)) .* rand(5,1));
thetaV=sort(-5.5 + (6-(-5.5)) .* rand(5,1)); 

PA_f=exp(thetaA)./(exp(thetaA)+1);
PV_f=exp(thetaV)./(exp(thetaV)+1);

PAV_f=zeros(5,5);
for a=1:5
    for v=1:5
        PAV_f(v,a) = (PA_f(a).*PV_f(v))./((PA_f(a).*PV_f(v))+((1-PA_f(a)).*(1-PV_f(v))));
    end
end

N=24;
pAVmatrix=[PA_f';PV_f';PAV_f];

for k=1:7
    data(k,:)=binornd(N,pAVmatrix(k,:));
end


%% Sample data for 5 subjects Early MLE
clearvars -except AllResults
clc;

param= -0.6 + (0-(-0.6)) .* rand(1,2);

sigmaA=exp(param(1));
sigmaV=exp(param(2));
cA=2.9 + (3.4-(2.)) .* rand(1,1); 
cV=1.8 + (3.2-(1.8)) .* rand(1,1);

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
N=24;
pAVmatrix=[PA_i;PV_i;PAV_i];

for k=1:7
    data(k,:)=binornd(N,pAVmatrix(k,:));
end


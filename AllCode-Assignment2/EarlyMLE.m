clearvars -except AllResults
clc;
%datasub=importdata('DataSub5.txt');


%datasub= AllResults.SimSubject1.MLE.data;
datasub= AllResults.SimSubject2.FLMP.data;


param0=rand([1,4]); %4 free parameters

fun=@(param)myfun2(param,datasub)
paramf=fminunc(fun,param0)

%% Then, we obtain the probabilities with the parameters obtained. 
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
for k=1:7
    pAVf_b(k,:)=binopdf(datasub(k,:),24,pAVmatrix_f(k,:));
end

%Ranges of Nlog(negative log likelihoods) between 53.54 - 72.80
N_log=-log(prod(prod(pAVf_b)))

%%
Results1.SimSubject5.MLE.loglike=N_log;
Results1.SimSubject5.MLE.pred_prob=pAVmatrix_f;

%% Scatter plot to estimate data 
mdlA = fitlm(datasub(1,:)/24,pAVmatrix_f(1,:));
mdlV = fitlm(datasub(2,:)/24,pAVmatrix_f(2,:));

mdlAV = fitlm(reshape(datasub(3:7,:)./24,[1,25]), reshape(pAVmatrix_f(3:7,:),[1,25]));
coefA=mdlA.Coefficients.Estimate;
coefV=mdlV.Coefficients.Estimate;
coefAV=mdlAV.Coefficients.Estimate;


x=0:0.1:1;
figure()
scatter(datasub(1,:)/24,pAVmatrix_f(1,:),70,'c','filled');hold on

scatter(datasub(2,:)/24,pAVmatrix_f(2,:),70,'m','filled');hold on

for i=3:7
    scatter(datasub(i,:)/24,pAVmatrix_f(i,:),70,'b','filled'); hold on
end

plot(x,(coefA(1)+coefA(2)*x),'--c', 'linewidth', 0.5);hold on;
plot(x,(coefV(1)+coefV(2)*x),'--m','linewidth', 0.5); hold on;
plot(x,(coefAV(1)+coefAV(2)*x),'--b', 'linewidth', 0.5);hold on;

legend('Auditory Response','Visual Response','AudioVisual Response')
xlabel('Response Proportions','FontWeight','bold')
ylabel('Early MLE Response Probabilities','FontWeight','bold')





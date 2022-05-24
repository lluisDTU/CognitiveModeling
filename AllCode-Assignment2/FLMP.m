
clearvars -except AllResults
clc;

%datasub=importdata('DataSub5.txt');
%datasub= AllResults.SimSubject5.MLE.data;
theta0=rand([1,10]); %auditory stimulus and visual  stimulus

fun=@(theta)myfun(theta,datasub)
thetaf=fminunc(fun,theta0)

%%
%Then, we obtain the probabilities with the parameters obtained. 
PA_f=exp(thetaf(1:5))./(exp(thetaf(1:5))+1)
PV_f=exp(thetaf(6:10))./(exp(thetaf(6:10))+1)

PAV_f=zeros(5,5);
for a=1:5
    for v=1:5
        PAV_f(v,a) = (PA_f(a).*PV_f(v))./((PA_f(a).*PV_f(v))+((1-PA_f(a)).*(1-PV_f(v))));
    end
end


pAVmatrix_f=[PA_f;PV_f;PAV_f];
N=24;
for k=1:7
    pAVf_b(k,:)=binopdf(datasub(k,:),N,pAVmatrix_f(k,:));
end

%Ranges of Nlog(negative log likelihoods) between 32.98 - 53.38
N_log= -log(prod(prod(pAVf_b)))



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
ylabel('FLMP Response Probabilities','FontWeight','bold')




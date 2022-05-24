
function Nlog = myfun(theta,datasub)

N=24;
thetaA=theta(1:5);
thetaV=theta(6:10);

PA_i=exp(thetaA)./(exp(thetaA)+1);
PV_i=exp(thetaV)./(exp(thetaV)+1);

PAV_i=zeros(5,5);
for a=1:5
    for v=1:5
        PAV_i(v,a) = (PA_i(a).*PV_i(v))./((PA_i(a).*PV_i(v))+((1-PA_i(a)).*(1-PV_i(v))));
    end
end

pAVmatrix=[PA_i;PV_i;PAV_i];

%error=sum(sum((pAVmatrix-(datasub/24)).^2));

%write binomial by hand
for k=1:7
    pAVf(k,:)=binopdf(datasub(k,:),N,pAVmatrix(k,:));
end

Nlog=-log(prod(prod(pAVf)));

end
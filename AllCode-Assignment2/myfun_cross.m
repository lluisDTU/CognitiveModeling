
function Nlog = myfun_cross(theta,datasub,cross)

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
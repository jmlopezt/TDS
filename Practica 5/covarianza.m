function [ a_cov,sigma] = covarianza( x,p )
% PRACTICA 5 TDS
% CALCULAMOS LOS COEFICIENTES AS POR EL METODO DE COVARIANZA
% SIMILAR A PRONY


%Obtenci?n de los coeficientes a_k
N=length(x);
R_x=zeros(p,p);
r_x_v=zeros(p,1);

for k=1:p
    for l=k:p
        r_x=0;
        for n=p:N-1
            r_x=r_x+x(n-k+1)*x(n-l+1);
        end
        R_x(k,l)=r_x;
        R_x(l,k)=r_x;
    end
    r_x_1=0;
    for n=p:N-1
        r_x_1=r_x_1+x(n-k+1)*x(n+1);
    end
    r_x_v(k)=r_x_1;
end

a=inv(R_x)*(-r_x_v);
sigma=x(p+1:end)'*x(p+1:end)+r_x_v'*a;
sigma=sigma/(N-p);
a=[1;a];
a_cov=a;




end


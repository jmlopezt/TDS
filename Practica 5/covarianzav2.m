function [a,sigma,RX] = covarianzav2( x,p )
% PRACTICA 5 TDS
% CALCULAMOS LOS COEFICIENTES A POR EL METODO DE COVARIANZA


%Obtencion de los coeficientes a_k
N=length(x);
C_x=zeros(p,p);
c_x=zeros(p,1);

for k=1:p
    C_x(k,k)=x(p-k+1:N-k)'*x(p-k+1:N-k);
    c_x(k)=x(p-k+1:N-k)'*x(p+1:N);
    for l=(k+1):p
        C_x(k,l)=x(p-k+1:N-k)'*x(p-l+1:N-l);
        C_x(l,k)=C_x(k,l);
    end
end
C_x=C_x/(N-p);
c_x=c_x/(N-p);

a=inv(C_x)*(-c_x);
sigma=x(p+1:N)'*x(p+1:N)/(N-p)+c_x'*a;
a=[1;a];

A=abs(fft(a,2*N-1)).^2;
RX=sigma./A;


end


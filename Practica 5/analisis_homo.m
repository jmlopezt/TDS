function [ Cepstrum ] = analisis_homo( x,p,L )
% An�lisis homom�rfico de una se�al para la obtenci�n de su Cepstrum
% Practica 5 TDS Juan Manuel L�pez Torralba

[a_cov,sigma]=covarianzav2(x,p);
A=abs(fft(a_cov,511)).^2;
RX_AR=sigma./A;
C_AR=log((RX_AR));
Cepstrum_LPC=ifft(C_AR); 

Cepstrum=Cepstrum_LPC(1:L+1);


end


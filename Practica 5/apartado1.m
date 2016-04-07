clear all
close all
clc

load e.asc
fs=8e03;
N=length(e);
k=0:N-1;
w=2*pi*k*fs/N;
Px=(abs(fft(e,N)).^2)/N;

figure
plot(k,e,'r')           % pitch 50 muestras
pitch1=50/8e03;
pitch2=(2*pi)/(1.194e4 - 1.1e4);
figure
plot(w,10*log10(Px));

%Las frecuencias de resonancia son los formantes.
%Se aprecia la ventana rectangular --> Ventana rectangular implica
%resolución pero también bastante varianza

% La aplicación de ventanas es un ejemplo del compromiso entre resolución
% y rizado (varianza de la estimación)


%% apartado 2

w=0:2*pi*fs/511:2*pi*fs*(510)/511;
p=12;

% Periodograma a partir de la autocorrelación

rx = xcorr(e,'biased');
RX=fft(rx,511);      

% Espectro AR(12) por el metodo de la autocorrelación

R_x=toeplitz(rx(N:N+p-1));
a=-inv(R_x)*rx(N+1:N+p);
sigma=rx(N)+rx(N+1:N+p)'*a;
a=[1;a];
A=abs(fft(a,511)).^2;
RX_AR=sigma./A;

a_lpc=lpc(e,p);
A_lpc=abs(fft(a_lpc,511)).^2;
RX_AR_lpc=sigma./A_lpc;

% Espectro AR(12) por el metodo de la covarianza

[a_cov,sigma_cov,RX_AR_COV]=covarianzav2(e,p);

%REPRESENTACIÓN GRAFICA

figure
plot(w,10*log10(abs(RX)),'b');        % Periodograma es un metodo no parametrico
hold on
plot(w,10*log10(RX_AR),'black');
hold on
plot(w,10*log10(RX_AR_lpc),'r');
hold on
plot(w,10*log10(RX_AR_COV),'g');
xlabel('w')
legend('Periodograma','Espectro AR(12) autocorr','Espectro AR(12) autocorr (lpc)','Espectro AR(12) covarianza')


% El metodo de covarianza proporciona una estimación más exacta que el de
% autocorrelación (no hay aproximaciones)

%El metodo de covarianza no garantiza la estabilidad del fltro resultante,
%mientras que el de autocorrelación sí.






%% apartado 3

C=log(abs(RX));
Cepstrum=ifft(C);        % a partir del periodograma
C_AR=log(abs(RX_AR));
Cepstrum_LPC=ifft(C_AR);  % Cepstrum LPC

figure
plot(Cepstrum,'b');      % para la muestra 51 
figure
plot(w,Cepstrum,'b');
hold on
plot(w,Cepstrum_LPC,'r')
legend('Cepstrum_{FFT}','Cepstrum_{LPC}');

% Se observa perfectamente como el Cepstrum LPC solo contiene información
% del tracto vocal (filtro) (que es la más importante ya que define el tipo
% de sonido que se ha emitido), mientras que el Cepstrum FFT contiene además
% información de la excitación


%% apartado 4
clear Cepstrum

load x.asc
load a.asc
load i.asc
load o.asc
load u.asc

Dist_euclid=zeros(1,5);
Vocales=[x a e i o u];
L=12;

for z=1:6
    Cepstrum(z,:)= analisis_homo( Vocales(:,z),p,L);
    if z~=1
   %   Dist_euclid(1,z-1)=abs(sum(Cepstrum(1,2:end)-Cepstrum(z,2:end)))^2;
      dif=Cepstrum(1,2:end)-Cepstrum(z,2:end);
      Dist_euclid(z-1)=dif*dif';
    end
    
end

disp('La vocal reconocida es:');
Reconocida=Dist_euclid<=(min(Dist_euclid))
disp('    a      e      i     o     u');


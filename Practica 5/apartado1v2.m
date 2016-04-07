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

%% apartado 2
w=0:2*pi*fs/511:2*pi*fs*(510)/511;
p=12;
rx = xcorr(e,'biased');
%plot(rx);
r_x=zeros(p,1)
RX=fft(rx,511);

R_x=toeplitz(rx(N:N+p-1));
r_x=rx(N+1:N+p);
a=-inv(R_x)*r_x;
a=[1;a];
a_lpc=lpc(e,p);
A=abs(fft(a_lpc,511)).^2;
RX_AR=1./A;
[a_cov,sigma]=covarianza(e,p);
A=abs(fft(a_cov,511)).^2;
RX_AR_COV=sigma./A;



figure
plot(w,10*log10(abs(RX)),'b');
hold on
plot(w,10*log10(RX_AR),'r');
hold on
plot(w,10*log10(RX_AR_COV),'g');
legend('Periodograma','AR_{autocorrelación}','AR_{covarianza}')
figure
plot(w,10*log10(abs(RX)),'b');


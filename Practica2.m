% Práctica 2
clear all
close all
clc

k=24;
a1=0;
a2=0.81;
a=[a1 a2];
b0=1;
p=2;
var_v=1;
l=0;
suma=0;

k=0;
Autocorr(k+1)=((var_v)/(1-(a2^2)))*(-a2)^k;              % rx(0)
Autocorr(k+2)=0;                                         % rx(1)
k=2;

for cont=3:2:23
        Autocorr(cont)=-a(2)*Autocorr(cont-2);
        Autocorr(cont+1)=0;
end

N=length(Autocorr);
Autocorr=[Autocorr(N:-1:2) Autocorr];
figure
q=(-length(Autocorr)/2):((length(Autocorr)/2) -1);
stem(q,Autocorr);
title('Autocorrelación')
xlabel('k muestras')
ylabel('r(k)')

%%
a=[1 0 0.81];

delta=2*pi/1999;
w=-pi:delta:pi-delta;
N=length(w);

Pot_analit=(abs(fft(a,N))).^2;
Pot_analit=1./Pot_analit;
figure
plot(w,Pot_analit);
title('PSD original')
xlabel('w')
ylabel('P(w)')


%%
b=[1 0 0];
N=500;
q=-999:999;
x=randn(1,N);
y=filter(b,a,x);
N=length(y);
x=0;
x=[y(N-23:1:N)];

x_biased=xcorr(x,'biased');
x_unbiased=xcorr(x,'unbiased');
q=(-length(Autocorr)/2):((length(Autocorr)/2) -1);

figure
subplot(1,2,1)
stem(q,x_biased)
title('Autocorrelación con sesgo')
xlabel('k muestras')
ylabel('r_biased(k)')
subplot(1,2,2)
stem(q,x_unbiased)
title('Autocorrelacion sin sesgo')
xlabel('k muestras')
ylabel('r_unbiased(k)')


figure
stem(q,x_biased,'g')
hold on 
stem(q,Autocorr,'r')
hold on
stem(q,x_unbiased,'b')
legend('Con sesgo a partir de ruido blanco filtrado','Autocorrelación a partir de YW inicial','Sin Sesgo a apartir de AWGN filtrado')
title('Comparación de las Autocorrelaciones obtenidas')
xlabel('muestras k')
ylabel('r(k)')

%%


delta=2*pi/1999;
w=-pi:delta:pi-delta;
N=length(w);

pot_biased=abs(fft(x_biased,N)).^2;
pot_unbiased=abs(fft(x_unbiased,N)).^2;
figure
subplot(2,1,1)
plot(w,abs(pot_biased))
title('PSD de la señal con sesgo obtenida a partir de AWGN')
xlabel('muestras k')
ylabel('P(w)')
subplot(2,1,2)
plot(w,abs(pot_unbiased))
title('PSD de la señal sin sesgo obtenida a partir de AWGN')
xlabel('w')
ylabel('P(w)')



% Ahora comparo con la obtenida al inicio

figure
plot(w,Pot_analit,'r')
hold on 
plot(w,abs(pot_biased),'black')
hold on
plot(w,abs(pot_unbiased),'b')
legend('PSD obtenida inicial a partir de YW','PSD de la señal con sesgo obtenida a partir de AWGN','PSD de la señal sin sesgo obtenida a partir de AWGN')
title('Comparación de las PSD obtenidas')
xlabel('w')
ylabel('P(w)')

%% Obtención de los coeficientes a a partir de x biased y las ecuaciones de Yule Walker
anew=0;
a1_new=0;
a2_new=0;
anew=[a1_new;a2_new];

R_xbiased=[x_biased(24) x_biased(25);x_biased(25) x_biased(24)];
R_xbiased_inv=inv(R_xbiased);
r_xbiased=[x_biased(25);x_biased(26)];
r_xbiased=-r_xbiased;
anew=(R_xbiased_inv)*(r_xbiased);

%%

a=[1 anew(1,1) anew(2,1)];

var_biased=var(x_biased);
delta=2*pi/1999;
w=-pi:delta:pi-delta;
N=length(w);

Pot_analit_biased=(abs(fft(a,N))).^2;
Pot_analit_biased=((1).^2)./Pot_analit_biased;

figure
plot(w,Pot_analit_biased);

figure
plot(w,Pot_analit_biased,'r');
hold on
plot(w,Pot_analit,'g')
title('Comparacion PSD original frente a la estimada correspondiente al modelo AR(2) estimado')
legend('PSD estimada correspondiente al modelo AR(2) estimado','PSD original')
xlabel('w')
ylabel('P(w)')


% Vemos que es el modelo correcto ya que los parametros estimados a partir
% de la autocorrelación sesgada que hemos obtenido se aproximan mucho a los
% dados originalmente, por tanto ambas PSD's se aproximan mucho y la
% estimación es tan buena.


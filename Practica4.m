%% Práctica 4 TDS CANCELADOR DE ECO ACÚSTICO 
%
%           Juan Manuel López Torralba
%

%% Lectura de ficheros y Cálculo de la SNR
clear all
close all
clc


load local.asc
load signal.asc
load remota.asc

x=remota;

SNR = 10*log10( sum(local.^2)/sum((local-signal).^2) );


%% Análisis  de la SNR con el algoritmo NMLS

deseada=signal;
a=1;
u(a)=0.0001;

while u(a)~=0.0512
    a=a+1;
    u(a)=u(a-1)*2;
end

p=1:10;


for i=1:1:length(p)
    for j=1:length(u)
        %[w,E] = cancel_eco(x,deseada,j,i);
        [w,E] = nlms(x,deseada,u(j),p(i));
        SNRs(i,j) = 10*log10( sum(local.^2)/sum((local-E').^2) );
        if (j>1) && (SNRs(i,j)>=SNRs(i,j-1))
            ubuena=u(j);
            pbuena=p(i);
        end
    end
end
SNRbuena=max(max(SNRs));  %  sale para p=5 y u(3)

pbuena=5;
ubuena=u(3);

wbuena=nlms(x,deseada,ubuena,pbuena);



lg=['b','g','r','k','m','c','y'];

figure
for contador=1:1:pbuena
    plot(wbuena(:,contador),lg(contador))
    hold on
end


if(0)
    sound(local)
    pause (2)
    sound(E)
end


%% apartado 3

for i=1:1:length(p)
    for j=1:length(u)
        %[w,E] = cancel_eco(x,deseada,j,i);
        [wfin,Efin] = cancel_eco_DoubleTalk(x,deseada,u(j),p(i));
        SNRsfin(i,j) = 10*log10( sum(local.^2)/sum((local-Efin').^2) );
        if (j>1) && (SNRsfin(i,j)>=SNRsfin(i,j-1))
            ufin(i)=u(j);
        end
    end
end
SNRbuenafin=max(max(SNRsfin));  %  sale para p=5 y u(3)



pbuenafin=5;
ubuenafin=ufin(pbuenafin);

wbuenafin=cancel_eco_DoubleTalk(x,deseada,ubuenafin,pbuenafin);

figure
for contador=1:1:pbuenafin
    plot(wbuenafin(:,contador),lg(contador))
    hold on
end

if(0)
    sound(local)
    pause (5)
    sound(Efin)
end
    
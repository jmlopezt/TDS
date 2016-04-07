%% Práctica 3 TDS

clear all
close all
clc


nd=5;
pfir=0;
piir=5;
qfir=10;
qiir=5;
N=11;

x=zeros(1,N);

for n=0:1:N-1
    x(n+1)=(sin((n-nd)*(pi/2)))./((n-nd).*pi);
    if (((n-nd).*pi) == 0)
        x(n+1)=0.5;
    end
end

delta=2*pi/(N-1);
w=-pi:delta:pi;
longW=length(w)
L=length(x)

stem(w,x);
axis([-pi pi -1 1]);

%% Aplico Pade
[ afir,bfir ] = pade( x,pfir,qfir )
[ aiir,biir ] = pade( x,piir,qiir )

%% Represento la respuesta en frecuencia de ambos casos.

% 1º CASO FIR      HfreqzFIR=((abs(fft(bfir,1024))).^2)./((abs(fft(afir,1024))).^2);   me da error de dimensiones así que lo hago paso a paso.

h=fft(bfir,1024);
h=abs(h);
h=h.^2;
h2=fft(afir,1024);
h2=abs(h2);
h2=h2.^2;
HfreqzFIR=h*(1./h2);

N=length(HfreqzFIR);
HfreqzFIR=[HfreqzFIR(N/2:1:(N-1)) HfreqzFIR(1:1:N/2)];

delta=2*pi/(N-1);
w=-pi:delta:pi;
figure
plot(w,HfreqzFIR)

% 2ª CASO IIR    % HfreqzIIR=((abs(fft(biir,1024))).^2)./((abs(fft(aiir,1024))).^2);

hiir=fft(biir,1024);
hiir=abs(hiir);
hiir=hiir.^2;
h2iir=fft(aiir,1024);
h2iir=abs(h2iir);
h2iir=h2iir.^2;
HfreqzIIR=(hiir./h2iir);

long=length(HfreqzIIR);
for i=1:3
    HfreqzIIR=[HfreqzIIR((long/2):1:(long-1)) HfreqzIIR(1:1:(long/2))];
end
long2=length(HfreqzIIR);

delta=2*pi/(long-1);
w=-pi:delta:pi;

figure
plot(w,HfreqzIIR)

figure
plot(w,HfreqzFIR,'r')
hold on
plot(w,HfreqzIIR,'g')
title('Respuesta en frecuencia PADE')
xlabel('w [rad/s]')
ylabel('H(w)')
legend('Filtro FIR','Filtro IIR')



%% APLICO PRONY al caso IIR

N=1000;

x=zeros(1,N);

for n=0:1:N-1
    x(n+1)=(sin((n-nd)*(pi/2)))./((n-nd).*pi);
    if (((n-nd).*pi) == 0)
        x(n+1)=0.5;
    end
end


if(0)
    [a,err] = covm(x,piir);
    
    HfreqzPRONY_CONV=1./((abs(fft(a,1024))).^2)
    N=length(HfreqzPRONY_CONV)
    figure
    plot(HfreqzPRONY_CONV)
end

[a2,b2,err_PRONY] = prony(x,piir,qiir)

HfreqzPRONY=((abs(fft(b2,1024))).^2)./((abs(fft(a2,1024))).^2)
N=length(HfreqzPRONY)

for i=1:3
    HfreqzPRONY=[HfreqzPRONY((N/2):+1:(N-1)) HfreqzPRONY(1:+1:(N/2))]
end

delta=2*pi/(N-1);
w=-pi:delta:pi;
figure
plot(w,HfreqzPRONY)


%% Aplico Shanks

[a,b,err_SHANKS] = shanks(x,piir,qiir)

HfreqzSHANKS=((abs(fft(b,1024))).^2)./((abs(fft(a,1024))).^2)
N=length(HfreqzSHANKS)

for i=1:3
    HfreqzSHANKS=[HfreqzSHANKS((N/2):+1:(N-1)) HfreqzSHANKS(1:+1:(N/2))]
end

delta=2*pi/(N-1);
w=-pi:delta:pi;
figure
plot(w,HfreqzSHANKS)

figure 
plot(w,HfreqzPRONY,'r')
hold on
plot(w,HfreqzIIR,'g')
hold on
plot(w,HfreqzSHANKS,'b')
title('Respuesta en frecuencia Filtros IIR')
xlabel('w [rad/s]')
ylabel('H(w)')
legend('PRONY','PADÉ','SHANKS')



%% filtro ELÍPTICO
N=5;
Rp=0.1;
Rs=40;
Wp=[.45];
[B,A] = ellip(N,Rp,Rs,Wp);

Hfreqzellip=((abs(fft(B,1024))).^2)./((abs(fft(A,1024))).^2)
N=length(Hfreqzellip)


    Hfreqzellip=[Hfreqzellip((N/2):+1:(N-1)) Hfreqzellip(1:+1:(N/2))]


delta=2*pi/(N-1);
w=-pi:delta:pi;
figure
plot(w,Hfreqzellip)



figure 
plot(w,HfreqzPRONY,'r')
hold on
plot(w,HfreqzIIR,'g')
hold on
plot(w,HfreqzSHANKS,'b')
hold on
plot(w,Hfreqzellip,'black')
title('Respuesta en frecuencia Filtros IIR')
xlabel('w [rad/s]')
ylabel('H(w)')
legend('PRONY','PADÉ','SHANKS','ELÍPTICO')




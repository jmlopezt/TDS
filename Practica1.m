% Práctica 1 TDS Juan Manuel López Torralba

% Pregunta 1  --> Determinar si la estimacion (1) propuesta para la autocorrelacion tiene o no desplazamiento (sesgo)
% Teoría      --> Diapositiva 23 Tema 2 :      1) E(r_estimado_x(k))=r_original_x(k) 
%                                            Estimación sin desplazamiento(unbiased)
%
%                                              2) VAR(r_estimado_x(k))-->0      
%                                            cuando N-->infinito
%                                            (estimador consistente)

% Respuesta 1 --> Sin embargo la ecuación 1 considera que x(n) toma valores
%                 nulos fuera del intervalo [0,N-1] y los usa en la estimación de la
%                 autocorrelación r_x(k).
%                                                 Diapositiva 24 -->
%                                                 r_estimado_x_(k) (este caso)=wb(k)*r_estimado_x(k) (del caso anterior)
%   por tanto:
%
%   1)            E(r_estimado_x(k))=wb(k)*r_original_x(k) --> Estimación con desviación(biased)                            
%   2)            VAR(r_estimado_x(k))-->0  cuando N-->infinito (estimador consistente)



%Pregunta 2 : Generar 1000 muestras de un ruido blanco Gaussiano de media nula y varianza unidad.

clear all
close all
clc

N=1000;
x=randn(1,N);        % proceso gaussiano de media nula y varianza unidad. Lo compruebo:

mediax=mean(x);
varianzax=var(x);


% Pregunta 3 : 

V=-(N-1):(N-1);

autocorrelacion=zeros(1000,1);
k=-(N-1):(N-1);

for i=1:N
    suma=0;
    for  n=i:N
         producto=x(n)*x(n-i+1);
         suma=suma+producto;
    end
    k=k-1;
    autocorrelacion(i)=suma/N;
end

c=[autocorrelacion(N:-1:2);autocorrelacion];       % Estimación realizada con bucles for

% usando convolucion conv
autocorrelacion2=conv(x,x(N:-1:1));
autocorrelacion2=autocorrelacion2./N;

figure 
plot(V,autocorrelacion2,'black')
hold on
plot(V,c,'g')
xlabel('K');
ylabel('r(k)');
title('Estimación de la autocorrelación')
legend('Usando conv','Estimada con bucles for');

%ejercicio 3
a=xcorr(x,'biased');
b=xcorr(x,'unbiased');

figure
subplot(1,2,1)
plot(V,a)
title('Con sesgo')
subplot(1,2,2)
plot(V,b,'r')
title('Sin Sesgo ')

%Explicación: (Diapositivas TDS Tema 2: 24)
% Con Sesgo:
%               Para k=0 la estimación de la autocorrelación es una delta que coincide con la autocorrelación original 
%               y conforme k va aumentando, nuestra estimación se va a
%               acercando a cero, esto es debido a la expresión r_estimado=(1 - k/N)*r_original 
%               y k como mucho llega N-1.
%               Por tanto cuando k=N-1 tendríamos r_estimado=(1 - 0.99999)*r_original) y esto es casi cero.    
%               Aunque no se aprecia muy bien (luego en el ejercicio5 se aprecia) vemos que es como aplicarle una ventana 
%               de  Barlett a la autocorrelación original. 

%               Cuando hacemos con sesgo estamos considerando que la señal
%               x toma valores cero fuera del intervalo de interés.
              



% Sin sesgo:    Se observa que en la autocorrelación sin sesgo, conforme k va aumentando
%               tambíen lo hace la variación de amplitud de la autocorrelación, esto se
%               debe a que a que al calcular la autocorrelación para cada k se divide por
%               (N - |k|) y como k--> N-1 tenemos que al final la estimación es muy mala
%               porque estamos estimando cada vez con menos muestras.



% Superpongo ahora las gráficas para observarlas en detalle y apreciar
% mejor este efecto que he descrito.

figure                                                                      % Vemos como para k=0 ambas estimaciones son iguales 
plot(V,b,'r')                                                               % a una delta y coinciden para k pequeño y conforme k aumenta se aprecia la diferencia
hold on
plot(V,a,'g')
title('Autocorrelación estimada con y sin sesgo')
legend('Sin sesgo','Con sesgo')




% Compruebo que me con xcorr biased sale igual que lo obtenido al principio
% con mi formula de bucles for

if(0)
    figure
    subplot(1,2,1)
    plot(V,a)
    subplot(1,2,2)
    plot(V,c,'r')
end



%Ejercicio 5      Obtener las estimaciones de la autocorrelación con sesgo y sin sesgo para el mismo ruido anterior
%                 pero con una media unitaria. ¿C´omo deber´?a ser la autocorrelaci ´on original en este caso? Explicar
%                 los resultados obtenidos.

x1=1+randn(1,N);

auto_biased=xcorr(x1,'biased');
auto_unbiased=xcorr(x1,'unbiased');

figure
subplot(1,2,1)                                                              % Obtenemos lo mismo que antes pero con un offset de 1; es decir como la 
plot(V,auto_biased)                                                         % media del ruido AWGN ahora es 1 pues tenemos las autocorrelaciones estimadas
title('Autocorrelación estimada con sesgo')                                 % desplazas hacia arriba una cantidad 1 que es la media del ruido.
subplot(1,2,2)                                                              % Aquí si se aprecia mucho mejor que la estimación con sesgo es como aplicar
plot(V,auto_unbiased,'r')                                                   % una ventana de Barlett a la autocorrelación original.
title('Autocorrelación estimada sin sesgo')



% Ejercicio 6                   Obtener la estimaci´on de la autocorrelaci ´on como el promedio de 100 autocorrelaciones, cada una de
%                               ellas obtenida a partir de una secuencia distinta de ruido blanco de media unidad. Se compararan los
%                               resultados obtenidos de usar los estimadores sesgado y no-sesgado para cada secuencia de ruido


y_biased=zeros(1,2*N-1);
y_unbiased=zeros(1,2*N-1);

for cont=1:100
    y=1+randn(1,N);
             y_biased=y_biased+xcorr(y,'biased');
             y_unbiased=y_unbiased+xcorr(y,'unbiased');

end

y_biased=y_biased./cont;
y_unbiased=y_unbiased./cont;


figure
subplot(1,2,1)
plot(V,y_biased)
title('Con sesgo')
xlabel('k')
ylabel('r(k)')
subplot(1,2,2)
plot(V,y_unbiased,'r')
title('Sin sesgo')
xlabel('k')
ylabel('r(k)')


% Vemos ahora que sale mucho mejor porque estamos haciendo el promedio de
% 100 autocorrelaciones donde en cada una de ella estamos considerando un
% ruido blanco de media 1 pero distinto, por tanto tenemos que al final se
% suaviza mucho la representación; esto es que estamos cometiendo mucho
% menos error al estimar la autocorrelación que en los casos anteriores.







clear all
close all

I=imread('tire.tif'); % Lectura de imagen tiff
I=single(I)/255; % Rango din´amico [0,1]
Nbins=256; % N´umero de subintervalos
[Npix,Cents]=imhist(I,Nbins); % C´omputo del histograma

[N,M]=size(I);
s=zeros(1,Nbins);
I_trans=zeros(N,M);

for i=1:Nbins
    s(i)=sum(Npix(1:i))/(N*M);
end

I_trans=histeq(I,s);
[Npix_trans,Cents_trans]=imhist(I_trans,Nbins);

figure;
stem(Cents,Npix);
figure;
imshow(I);
figure;
stem(Cents_trans,Npix_trans); 
figure;
imshow(I_trans);

Hd = zeros(11,11);
Hd(4:8,4:8)=ones(5,5);
h = fwind1(Hd,hamming(11));
[f1,f2]=freqspace([11 11]);
[x,y]=meshgrid(f1,f2);
colormap(jet(64))
subplot(1,2,1), surf(x,y,Hd), axis([-1 1 -1 1 0 1.2])
subplot(1,2,2), freqz2(h,[32 32]), axis([-1 1 -1 1 0 1.2])

load clown % Cargar imagen indexada
figure;
imshow(X,map);
I=ind2gray(X,map); % Convertir a imagen de gris
J = imnoise(I,'salt & pepper'); % Contaminar con ruido sal y pimienta
J_f=medianfilter(J,3,3);
figure;
imshow(J);
figure;
imshow(J_f);

%%% Transformada de Fourier y espectro
% Cargar imagen y convertir a niveles de gris
load mandrill
imshow(X,map)
pause
I=ind2gray(X,map);
imshow(I)
pause
% Se selecciona una subimagen con una textura clara
B=I(130:130+100,150:150+200);
imshow(B)
pause
% Computar FFT2
F=fft2(B);
imshow(20*log10(abs(F)));
pause
image(20*log10(abs(F)));
pause
%colormap(jet(64))
imagesc(20*log10(abs(F)));
pause
F=fftshift(F);
imagesc(20*log10(abs(F)));
pause;
image(20*log10(abs(F)))

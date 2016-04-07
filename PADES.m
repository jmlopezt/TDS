function [ a,b ] = PADES( x,p,q )
% JUAN MANUEL LÓPEZ TORRALBA
%           TDS
%Esta función calcula los coeficientes a y b del modelo de Padé a partir de
%una señal x y los parámetros p y q proporcionados como dato
%

if(0) %prueba
    f=-pi:0.0001:pi;
    x=sin(2*pi*f);
    p=0;
    q=5;
end
% fin prueba



p_aux=p;
q_aux=q

%% Cálculo de los coeficientes "a"
if(p_aux~=0 | p~=0)
    
    fila=q:1:q+p-1;
    col=q:-1:q-p+1;
    fila=length(fila);
    col=length(col);
    
    I=zeros(fila,col);
    
    p=p+1;
    q=q+1;
    
    indice=q:-1:q-p+2;
    
    for contfila=1:1:fila
        
        %   while indice > 0
        %       I(contfila,:)=x(indice);
        %   end
        
        for i=1:1:length(indice)
            if(indice(i)>0)
                I(contfila,i)=x(indice(i));
            else
                I(contfila,i)=0;
            end
        end
        
        indice=indice+1;
    end
    
    fila=0;col=0;contfila=0;indice=0;
    
    indice=q+1:q+p-1;
    fila=q_aux+1:1:q_aux+p_aux;
    fila=length(fila);
    
    D=zeros(fila,1);
    D(:,1)=x(indice);
    
    A=zeros(p_aux,1);
    I=inv(I);
    A=-I*D;
else
    A=0;
    I=0;
    D=0;
end
a=A;
b=0;

%% Cálculo de los coeficientes "b"

B=zeros(q,1);
if (p_aux~=0 | p~=0)
A_aux=[1;A];
else
    A_aux=1;
end
col=q_aux:-1:(q_aux-p_aux);
indice=0:1:q_aux;
indice=indice+1;

for contcol=1:1:length(col)
    for i=1:1:length(indice)
        if(indice(i)>0)
            M(i,contcol)=x(indice(i));
        else
            M(i,contcol)=0;
        end
    end
    indice=indice-1;
end

B=M*A_aux;

b=B;
a=A;

end


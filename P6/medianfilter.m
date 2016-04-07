function [A_f] = medianfilter(A,N,M)

% Nota: Se asume que N y M deben ser impares

[filas,colum]=size(A);
A_f=zeros(filas,colum);

for i=1:filas
    for j=1:colum
        
        n_sup=i+(N-1)/2;
        if (n_sup>filas)
            n_sup=filas;
        end
        
        n_inf=i-(N-1)/2;
        if (n_inf<1)
            n_inf=1;
        end
        
        m_sup=j+(M-1)/2;
        if (m_sup>colum)
            m_sup=colum;
        end
        
        m_inf=j-(M-1)/2;
        if (m_inf<1)
            m_inf=1;
        end
        
        a=reshape(A(n_inf:n_sup,m_inf:m_sup),1,(n_sup-n_inf+1)*(m_sup-m_inf+1));
        A_f(i,j)=median(a);
    end
end


end


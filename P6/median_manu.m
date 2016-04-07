function [A_f] = median_manu( A )
%filtrado no lineal
for i=1:200
    for j=1:320
        if i==1 && j==1
            A=[J(i,j) J(i,j+1);J(i+1,j) J(i+1,j+1)];
            x=reshape(A',4,1);
            y(i,j)=median(x);

        elseif i==1 && j>1 && j<320
            A=[J(i,j-1) J(i,j) J(i,j+1); J(i+1,j-1) J(i+1,j) J(i+1,j+1)];
            x=reshape(A',6,1);
            y(i,j)=median(x);

        elseif i==1 && j==320
            A=[J(i,j-1) J(i,j);J(i+1,j-1) J(i+1,j)];
            x=reshape(A',4,1);
            y(i,j)=median(x);

        elseif i>1 && i<200 && j==1
            A=[J(i-1,j) J(i-1,j+1);J(i,j) J(i,j+1);J(i+1,j) J(i+1,j+1)];
            x=reshape(A',6,1);
            y(i,j)=median(x);

        elseif i==200 &&  j==1
            A=[J(i-1,j) J(i-1,j+1); J(i,j) J(i,j+1)];
            x=reshape(A',4,1);
            y(i,j)=median(x);

        elseif i>1 && i<200 && j==320
             A=[J(i-1,j-1) J(i-1,j);J(i,j-1) J(i,j);J(i+1,j-1) J(i+1,j)];
             x=reshape(A',6,1);
             y(i,j)=median(x);

        elseif i==200 && j==320
             A=[J(i-1,j-1) J(i-1,j);J(i,j-1) J(i,j)];
             x=reshape(A',4,1);
             y(i,j)=median(x);

        elseif i==200 && j>1 && j<320
             A=[J(i-1,j-1) J(i-1,j) J(i-1,j+1);J(i,j-1) J(i,j) J(i,j+1)];
             x=reshape(A',6,1);
             y(i,j)=median(x);
        else
        A=[J(i-1,j-1) J(i-1,j) J(i-1,j+1);J(i,j-1) J(i,j) J(i,j+1); J(i+1,j-1) J(i+1,j) J(i+1,j+1)];
        x=reshape(A',9,1);
        y(i,j)=median(x);
        end
    end
end

A_f=A;

end


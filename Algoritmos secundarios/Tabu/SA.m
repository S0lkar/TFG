function [Best,c] = SA(ini, N)

    T= 1000;
    %Current = randperm(N);%estado inicial aleatorio
    Current = ini;
    Best = ini;
    c=0;
        while(T>=1 && fEval(Current)~=0)
            New = SARandomSuccessor(Current); %nuevo sucesor del estado aleatorio
            deltaE = fEval(New) - fEval(Current);
            if ( deltaE < 0)
                Current = New;
                Best = New;
            else
                %Calculo de probabilidad y vemos si es aceptado
                p = exp(-deltaE/T);
                if p > rand(0, 1)
                    Current = New;
                end
            end
            %enfriamos T
            T = T*0.8;
            c=c+1;
        end

end
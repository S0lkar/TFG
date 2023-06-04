function S = PartialSuccessor(A, rAct)
    %% Obtenemos los sucesores de A;
    N = length(A);
    S = [];
    
    for i = 1:N
        if(i ~= rAct)
             Aux = A;
             Aux([i rAct]) = Aux([rAct i]);            
             S = [S; [Aux fEval(Aux)]];
        end
    end
    
    S = sortrows(S, size(S, 2));
end



function ListSuccesors=tabuListSuccesorStates(x)
% x is	a	complete	assignment
% v is	 the	 queen	 to	 consider	 in	 order	 to	 generate	 new	successors only	 by	 exchanging	
%values	of	this	queen	with	the	rest	of	queens
i=1;
v=1;
S=x;
N=length(x);%REVISAR PORQ GENERA TODOS LOS SUCESORES Y A EL MISMO TAMB
cont=1;
ListSuccesors=[];   % Tendra la forma de una matriz que por cada fila sera un sucesor y la ultima columna su fEval
Eval = [];
while v <= length(x)
    i=v+1;
    while i <= length(x) 
        S = x;
        if v ~= i
            S([v i]) =  S([i v]);
            v;
            i;
            cont;
            ListSuccesors(cont,:) = S(:);

            Eval(cont) = fEval(S);
            cont = cont +1;
        end
        i = i+1;
    end
    v = v+1;
end

% Concatenamos matriz de sucesores con la de la funcion de evaluacion
ListSuccesors = [ ListSuccesors Eval'];
% Ordenamos la lista de sucesores obtenida segun su fEval, ULTIMA COLUMNA, de menos a mas
ListSuccesors = unique(ListSuccesors,"rows","stable");
[~,s] = sort(ListSuccesors(:,N+1));
ListSuccesors = ListSuccesors(s,:);

end
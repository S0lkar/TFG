
% Algoritmo en 'ArgumentArmament.png'.
% Recibe las coordenadas como pares (X,Y). Devuelve el polígono de 
% mínimo perímetro asociado P.
% Sp es 'sorting preference'. Si tiene una forma ovalada, poner el eje más
% estrecho
% DSP es si quiero display o no
function P = PolyGrowth(C, DSP, Sp)
    if nargin == 2
        Sp = 1; % Eje X por defecto
    end
    Corg = C; % Copia de las coordenadas de origen
    mCostes = creaMC(C); % Placeholder
    [C, Ord] = sortrows(C, Sp); % ~O(n log(n))
    P = Ord;

    for i = 4:length(C) % ~ O(n) * O(interior) 
        % Ahora tengo en P(1:i-1) la ruta anterior al punto, y en Anillo qué puntos forman el nuevo convex 
        Anillo = convhulln(C(1:i, :)); Anillo = P(Anillo(:, 1));
        ref = find(Anillo == P(i), 1); % dónde se encuentra el punto nuevo.

        
        % Y si la referencia es el 1 qué...
        Ext(1) = Anillo(ref-1); Ext(2) = Anillo(ref+1); % Parte donde se insertará el punto
        Path(1) = find(P == Ext(2), 1);
        Path(2) = find(P == Ext(1), 1);

        if Path(2) - Path(1) > 1 % Hay puntos entre los dos a unir
            % Va a haber que basarlo en la ruta y no en el anillo anterior
            Insertar = Corte(Corg, P(Path(1):Path(2)), P(i)) + Path(1) - 1;
        else
            Insertar = Path(1);
        end
        
        aux = P(i); P(i) = []; % No sé si esta forma de reinsertar es la mejor
        auxC = C(i, :); C(i, :) = [];
        P = [P(1:Insertar); aux; P(Insertar+1:end)];
        C = [C(1:Insertar, :); auxC; C(Insertar+1:end, :)];


        % Parece que aplicar la tensión superficial tan constante no hace
        % bien, no
%         Anillo = convhulln(C(1:i, :)); Anillo = P(Anillo(:, 1));
%         aux = TnsSup(P(1:i)', flip(Anillo), mCostes);
%         if fcost(aux, mCostes) < fcost(P(1:i), mCostes)
%             P(1:i) = aux';
%         end

        if DSP == true
            plotAnillo(Anillo', Corg, 'b');
            plotAnillo(P(1:i)', Corg, 'r');
            hold off;
        end
    end

end


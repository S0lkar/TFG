
% Actualiza el segmento i del conjunto al nuevo dado.
function [Indices, Len] = Substituir_Segmento(Indices, Len, Segmento, i)

    if i == 1
        inicio = Len(1) + 1;
        Indices = [Segmento; Indices(inicio:end)];
    elseif i == length(Len)
        final = sum(Len(1:i-1)) - (i-1);
        Indices = [Indices(1:final); Segmento];
    else
        inicio = sum(Len(1:i-1)) - (i-1); % cortamos hasta el fin de la capa anterior
        final = sum(Len(1:i)) - (i-1) + 1; % y seguimos desde el inicio de la capa posterior
        Indices = [Indices(1:inicio); Segmento; Indices(final:end)];
    end

    Len(i) = length(Segmento);
end


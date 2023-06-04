function mCostes = creaMC(Coordenadas)
    mCostes = zeros(length(Coordenadas), length(Coordenadas));
    
    for i = 1:length(Coordenadas)
        for j = i:length(Coordenadas)
            mCostes(i, j) = d_euclid(Coordenadas(i, :)', Coordenadas(j, :)');
            mCostes(j, i) = mCostes(i, j);
        end
    end
end


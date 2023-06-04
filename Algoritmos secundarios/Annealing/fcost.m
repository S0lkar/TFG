function Total = fcost(asig, mCostes)
    N = length(asig);
    Total = mCostes(asig(N), asig(1));
    for i = 1:N-1
        Total = Total + mCostes(asig(i), asig(i+1));
    end
end
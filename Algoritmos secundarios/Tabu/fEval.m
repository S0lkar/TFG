function e=fEval(x)  
    e=0;
    for i=1:length(x)
    reina=x(i);

        for j=i+1:length(x)
            
            if(reina == x(j) || abs(i-j) == abs(reina - x(j) ) )
                e=e+1;         
            end
           
        end
       
    end

end
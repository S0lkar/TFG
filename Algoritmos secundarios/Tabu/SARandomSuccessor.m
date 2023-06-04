function New = SARandomSuccessor(Current)
N=length(Current);
New=Current;
pos1=randi(N);
pos2=randi(N);
    while pos1==pos2
        pos2=randi(N);
    end
        New([pos1 pos2]) =  New([pos2 pos1]);
  
end
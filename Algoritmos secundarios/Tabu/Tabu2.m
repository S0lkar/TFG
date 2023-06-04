function [Best,i] = Tabu2(ini, N)

Current = ini;%initial state
Best=Current;
Best_cost=fEval(Best);
%% Initial values
tenure=4;
tabu_list= uint8 (zeros(N,N));
max_iter = 100;
i=0;
mov = [0, 0];
New=zeros(1,N);
%% Comienzo

while (fEval(Best)~=0 && i<max_iter)
% Obtain list succesors states ordered by cost function
    [Succesor_list] = PartialSuccessor(Current, mod(i, N) + 1); % tabuListSuccesorStates(Current);
    Origen = Current;
    New = Succesor_list(1, 1:N);
    New_cost = Succesor_list(1,end); 
    Succesor_list = Succesor_list(2:end, :);    
    Origen = Current;
while ~isempty(Succesor_list) & Current == Origen

    mov = find((Current ~= New)==1);% apuntamos movimiento que se hizo

    if New_cost < Best_cost
        Current=New;
        Best=Current;
        Best_cost=fEval(Current);

    elseif ~isempty(mov) && tabu_list(mov(1),mov(2))==0
        Current=New;
    else
        New=Succesor_list(1,1:N);
        Succesor_list = Succesor_list(2:end, :);
    end
end
%Update tabu list (decreasing tenure and adding new tabu state) 
    %decrementar la matriz uno
    tabu_list = tabu_list-1;
    if ~isempty(mov)
        % poner mov a tabu, Update tabu list
        tabu_list(mov(1),mov(2))=tenure;
        tabu_list(mov(2),mov(1))=tenure;
    end
    %Update rest of variables
i=i+1;
end


end
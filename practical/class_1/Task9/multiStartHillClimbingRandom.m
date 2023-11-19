function [bestSol, bestLoads, bestLoad, contador, somador,bestLoadTime] = multiStartHillClimbingRandom(sP, nSP, T, nNodes, Links, timeLimit)
    nFlows = height(T);
    t= tic;
    bestLoad= inf;  % objective function value
    contador= 0;
    somador= 0;
    
    while toc(t) < timeLimit
        % Generate a random initial solution
        sol= zeros(1,nFlows);
        for f= 1:nFlows
            sol(f)= randi(nSP(f));
        end

        Loads = calculateLinkLoads(nNodes, Links, T, sP, sol);
        load = max(max(Loads(:, 3:4)));
        
        % Perform hill climbing on the random initial solution
        [sol, load] = hillClimbing(sP, nSP, T, nNodes, Links, sol, load);
        
        % Update the best solution if a better one is found
        if load < bestLoad
            bestSol = sol;
            bestLoads = Loads;
            bestLoad = load;
            bestLoadTime= toc(t);
        end
        
        contador = contador + 1;
        somador = somador + load;
    end
end

function [bestSol, bestLoads, bestLoad, contador, somador,bestLoadTime] = multiStartHillClimbingRandom(sP, nSP, T, nNodes, Links, timeLimit)
    nFlows = height(T);
    t= tic;
    bestLoad= inf;  % objective function value
    contador= 0;
    somador= 0;
    
    % Initialize best solution
    bestSol = zeros(1, nFlows);
    bestLoads = calculateLinkLoads(nNodes, Links, T, sP, bestSol);
    
    while toc(t) < timeLimit
        % Generate a random initial solution
        sol = randi([1, max(nSP)], 1, nFlows);
        
        % Perform hill climbing on the random initial solution
        [sol, Loads, load] = hillClimbing(sP, nSP, T, nNodes, Links, sol);
        
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

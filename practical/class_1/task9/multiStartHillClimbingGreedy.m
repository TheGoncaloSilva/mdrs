function [bestSol, bestLoads, bestLoad, contador, somador, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, timeLimit)
    nFlows = height(T);
    t= tic;
    bestLoad= inf;  % objective function value
    contador= 0;
    somador= 0;
    
    % Initialize best solution
    bestSol = zeros(1, nFlows);
    bestLoads = calculateLinkLoads(nNodes, Links, T, sP, bestSol);
    
    while toc(t) < timeLimit
        % Generate initial solution using Greedy Randomized approach
        [sol, ~, load, ~, ~, ~] = greedyRandomizedStrategy(sP, nSP, T, nNodes, Links, 5);
        
        % Perform hill climbing on the Greedy Randomized initial solution
        [sol, load] = hillClimbing(sP, nSP, T, nNodes, Links, sol, load);
        
        % Update the best solution if a better one is found
        if load < bestLoad
            bestSol = sol;
            bestLoad = load;
            bestLoadTime= toc(t);
        end
        
        contador = contador + 1;
        somador = somador + load;
    end
end

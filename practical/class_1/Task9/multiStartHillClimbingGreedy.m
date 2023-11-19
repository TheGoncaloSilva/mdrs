function [bestSol, bestLoads, bestLoad, contador, somador, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, timeLimit, numIterations)
    nFlows = height(T);
    t= tic;
    bestLoad= inf;  % objective function value
    contador= 0;
    somador= 0;
    
    % Initialize best solution
    bestSol = zeros(1, nFlows);
    bestLoads = calculateLinkLoads(nNodes, Links, T, sP, bestSol);
    
    while contador < numIterations && toc(t) < timeLimit
        % Generate initial solution using Greedy Randomized approach
        sol = greedyRandomized(sP, nSP, T, nNodes, Links);
        
        % Perform hill climbing on the Greedy Randomized initial solution
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

function sol = greedyRandomized(sP, nSP, T, nNodes, Links)
    nFlows = height(T);
    sol = zeros(1, nFlows);
    
    % Greedy Randomized approach to generate initial solution
    for f = randperm(nFlows)
        auxBest = inf;
        
        for i = 1:nSP(f)
            sol(f) = i;
            auxLoads = calculateLinkLoads(nNodes, Links, T, sP, sol);
            auxLoad = max(max(auxLoads(:, 3:4)));
            
            if auxLoad < auxBest
                auxBest = auxLoad;
                ibest = i;
            end
        end
        
        sol(f) = ibest;
    end
end

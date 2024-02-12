function [bestSol, bestLoads, bestLoad, contador, somador, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, timeLimit)
    %% Attention: this is modification of the algorithm available in task 9
    %   for the challenge exercise, please don't use it outside of this
    %   scope
    nFlows = height(T);
    t= tic;
    bestLoad= inf;  % objective function value
    contador= 0;
    somador= 0;
   
    while toc(t) < timeLimit
        % Generate initial solution using Greedy Randomized approach
        sol= zeros(1,nFlows);
        for f= randperm(nFlows)
            auxBest= inf;
            for i=1:nSP(f)
                sol(f)= i;
                auxLoads= calculateLinkBand1to1(nNodes,Links,T,sP,sol);
                auxLoad= max(max(auxLoads(:,3:4)));
                if auxLoad < auxBest
                    auxBest= auxLoad;
                    ibest=i;
                end
            end
            sol(f)= ibest;
        end

        Loads= calculateLinkBand1to1(nNodes,Links,T,sP,sol);
        load= max(max(Loads(:,3:4)));   % calculate max capacity of link loads
        
        % Perform hill climbing on the Greedy Randomized initial solution
        [sol, load] = hillClimbing(sP, nSP, T, nNodes, Links, sol, load);
        
        % Update the best solution if a better one is found
        if load < bestLoad
            bestSol = sol;
            bestLoad = load;
            bestLoads = Loads;
            bestLoadTime= toc(t);
        end
        
        contador = contador + 1;
        somador = somador + load;
    end
end

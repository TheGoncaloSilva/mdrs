function [bestSol, bestLoads, bestEnergy, contador, somador, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, timeLimit, alpha, L, C)
    nFlows = height(T);
    t= tic;
    bestEnergy= inf;  % objective function value
    contador= 0;
    somador= 0;
    
    while toc(t) < timeLimit
        continuar= true;
        % Respect alpha
        while continuar 
            continuar= false;
            % Generate initial solution using Greedy Randomized approach
            sol= zeros(1,nFlows);
            for f= randperm(nFlows)
                ibest= 0;
                auxBestEnergy= inf;
                for i=1:nSP(f)
                    sol(f)= i;
                    auxLoads= calculateLinkLoads(nNodes,Links,T,sP,sol);
                    auxLoad= max(max(auxLoads(:,3:4)));
                    % assuming equal link capacity in each direction
                    if auxLoad <= (alpha * C)
                        auxenergy= calculateEnergyConsumption(L, auxLoads, T, sol, sP);
                        if  auxenergy < auxBestEnergy
                            auxBestEnergy= auxenergy;
                            ibest= i;
                        end
                    end
                end
                if ibest > 0
                    sol(f)= ibest;
                else
                    continuar= true;
                    break;
                end
            end
        end
        Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
        energy= calculateEnergyConsumption(L, Loads, T, sol, sP);
        
        % Perform hill climbing on the Greedy Randomized initial solution
        [sol, ~]= hillClimbing(sP, nSP, T, nNodes, Links, sol, energy, L, alpha, C);
        Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
        energy= calculateEnergyConsumption(L, Loads, T, sol, sP);

        % Update the best solution if a better one is found
        if energy < bestEnergy
            bestSol = sol;
            bestEnergy= energy;
            bestLoads = Loads;
            bestLoadTime= toc(t);
        end
        
        contador = contador + 1;
        somador = somador + energy;
    end
end

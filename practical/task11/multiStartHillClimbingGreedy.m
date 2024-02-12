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
                    if auxLoad <= (alpha * 10) % assuming equal link capacity -> 10
                        auxenergy= calculateEnergyConsumption(L, auxLoads);
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
        energy= calculateEnergyConsumption(L, Loads);
        %load= max(max(Loads(:,3:4)));   % calculate max capacity of link loads
        
        % Perform hill climbing on the Greedy Randomized initial solution
        [sol, ~]= hillClimbing(sP, nSP, T, nNodes, Links, sol, energy, L, C, alpha);
        Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
        energy= calculateEnergyConsumption(L, Loads);

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

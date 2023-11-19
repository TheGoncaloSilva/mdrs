function [bestSol, bestLoads, bestLoad, contador, somador, bestLoadTime] = greedyRandomizedStrategy(sP, nSP, T, nNodes, Links, timeLimit)
    nFlows = height(T);
    t= tic;
    bestLoad= inf;  % objective function value
    contador= 0;
    somador= 0;
    while toc(t) < timeLimit
        sol= zeros(1,nFlows);
        for f= randperm(nFlows)
            auxBest= inf;
            for i=1:nSP(f)
                sol(f)= i;
                auxLoads= calculateLinkLoads(nNodes,Links,T,sP,sol);
                auxLoad= max(max(auxLoads(:,3:4)));
                if auxLoad < auxBest
                    auxBest= auxLoad;
                    ibest=i;
                end
            end
            sol(f)= ibest;
        end
        Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
        load= max(max(Loads(:,3:4)));   % calculate max capacity of link loads
        if load<bestLoad
            bestSol= sol;
            bestLoad= load;
            bestLoads= Loads;
            bestLoadTime= toc(t);
        end
        contador= contador+1;
        somador= somador+load;
    end
end
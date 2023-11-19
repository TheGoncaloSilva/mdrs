function [bestSol, bestLoads, bestLoad, contador, somador, bestLoadTime] = randomStrategy(sP, nSP, T, nNodes, Links, timeLimit)
    nFlows = height(T);
    t= tic;
    bestLoad= inf;  % objective function value
    contador= 0;
    somador= 0;
    while toc(t) < timeLimit
        sol= zeros(1,nFlows);
        for f= 1:nFlows
            sol(f)= randi(nSP(f));
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
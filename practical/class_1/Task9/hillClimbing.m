function [sol, bestLoads, bestLoad] = hillClimbing(sP, nSP, T, nNodes, Links, sol)
    bestLoads = calculateLinkLoads(nNodes, Links, T, sP, sol);
    bestLoad = max(max(bestLoads(:, 3:4)));
    
    improved = true;
    while improved
        improved = false;
        
        for f = randperm(length(sol))
            currentFlow = sol(f);
            
            for i = 1:nSP(currentFlow)
                if sol(f) ~= i
                    % Try assigning a different value to the flow
                    sol(f) = i;
                    
                    % Calculate new loads and check if it's an improvement
                    Loads = calculateLinkLoads(nNodes, Links, T, sP, sol);
                    load = max(max(Loads(:, 3:4)));
                    
                    if load < bestLoad
                        bestLoads = Loads;
                        bestLoad = load;
                        improved = true;
                    else
                        % Revert the change if no improvement
                        sol(f) = currentFlow;
                    end
                end
            end
        end
    end
end
function [sol, load] = hillClimbing(sP, nSP, T, nNodes, Links, sol, load)
    % This function represents a First Best Neighbor (FBN) move variant 
    % within the context of a hill-climbing algorithm. It explores adjacent 
    % solutions by considering the first neighboring solution that improves 
    % upon the current solution's objective (in this case, reducing the 
    % maximum link load).


    nFlows = size(T, 1);

    bestLocalLoad = load;
    bestLocalSol = sol;
    improved = true;

    while improved
        improved = false;
            
        % cycle flows
        for flow = 1:nFlows
            % test each path
            for path = 1:nSP(flow) 
                % check that the current path is different from the one in the solution
                if path ~= sol(flow)
                    % Create a new changed solution
                    auxSol = sol;
                    auxSol(flow) = path;

                    % Calculate the loads of this solution
                    Loads = calculateLinkLoads(nNodes, Links, T, sP, auxSol);
                    auxLoad = max(max(Loads(:, 3:4)));
                    
                    % check if this solution is better than the previous
                    % found one
                    if auxLoad < bestLocalLoad
                        bestLocalLoad = auxLoad;
                        bestLocalSol = auxSol;
                    end
                end
            end
        end
          
        % if better link load is found for a solution, change to it
        if bestLocalLoad < load
            load = bestLocalLoad;
            sol = bestLocalSol;
            improved = true;
        end
    end
end
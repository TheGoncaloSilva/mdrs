function [costs, sP] = optimizePath(nNodes, anycastNodes, D, k)
    sP = cell(1, nNodes);
    costs = zeros(1, nNodes);
    
    for n = 1:nNodes
        best = inf;
        
        if ismember(n, anycastNodes)
            costs(n) = 0;   % anycast node has zero cost to itself
        else
            for a = 1:length(anycastNodes)
                [shortestPath, totalCost] = kShortestPath(D, n, anycastNodes(a), k);
        
                % Check if the current total cost is better than the best cost found so far
                if totalCost < best
                    sP{n} = shortestPath;
                    best = totalCost;
                    costs(n) = totalCost;
                end
            end
        end
    end
end

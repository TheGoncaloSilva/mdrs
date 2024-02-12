function [costs, sP, nSP]= anycastDestination(nodes, anycastNodes, D, k)
    nNodes= length(nodes);
    sP= cell(1, nNodes);
    nSP= zeros(1,nNodes);
    costs= zeros(k, nNodes);
    
    for n= 1:nNodes
        best= inf;
        
        if ismember(nodes(n), anycastNodes)
            costs(n)= 0;   % anycast node has zero cost to itself
        else
            % Choose the anycast node with the smallest delay
            for a = 1:length(anycastNodes)
                [shortestPath, totalCost]= kShortestPath(D, nodes(n), anycastNodes(a), k);
        
                % Check if the current total cost is better than the best cost found so far
                if totalCost < best
                    sP{n}= shortestPath;
                    nSP(n)= length(totalCost);
                    best= totalCost;
                    costs(:,n)= totalCost;
                end
            end
        end
    end
end
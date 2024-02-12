function [sol, load] = hillClimbing2(sP, nSP, T, nNodes, Links, sol, D)
    nFlows = size(T, 1);

    % Identify the indices corresponding to T1 and T2 flows
    T1_indices = 1:size(T, 1);
    T2_indices = size(T, 1)+1:nFlows;

    bestLocalDelay = calculateRoundTripDelay(nNodes, Links, T, sP, sol, D);
    bestLocalSol = sol;
    improved = true;

    while improved
        improved = false;

        % Cycle through all flows
        for flow = 1:nFlows
            % Test each path
            for path = 1:nSP(flow) 
                % Check that the current path is different from the one in the solution
                if path ~= sol(flow)
                    % Create a new changed solution
                    auxSol = sol;
                    auxSol(flow) = path;

                    % Calculate the round-trip delay of this solution
                    auxDelay = calculateRoundTripDelay(nNodes, Links, T, sP, auxSol, D);

                    % Weighted sum of round-trip delays, giving higher weight to T1
                    weightedSumAuxDelay = sum(auxDelay(T1_indices)) + 0.5 * sum(auxDelay(T2_indices));

                    % Weighted sum of round-trip delays for the best solution found so far
                    weightedSumBestDelay = sum(bestLocalDelay(T1_indices)) + 0.5 * sum(bestLocalDelay(T2_indices));

                    % Check if this solution is better than the previous found one
                    if weightedSumAuxDelay < weightedSumBestDelay
                        bestLocalDelay = auxDelay;
                        bestLocalSol = auxSol;
                    end
                end
            end
        end

        % If a better round-trip delay is found for a solution, change to it
        if max(bestLocalDelay(T1_indices)) < max(calculateRoundTripDelay(nNodes, Links, T, sP, sol, D))
            sol = bestLocalSol;
            load = max(bestLocalDelay(T1_indices));
            improved = true;
        else
            % If no improvement is found, set load to the current value
            load = max(calculateRoundTripDelay(nNodes, Links, T, sP, sol, D));
        end
    end
end

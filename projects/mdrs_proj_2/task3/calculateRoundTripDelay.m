function roundTripDelay = calculateRoundTripDelay(nNodes, Links, T, sP, Solution, D)
    nFlows = size(T, 1);
    roundTripDelay = zeros(nFlows, 1);

    for i = 1:nFlows
        if Solution(i) > 0
            path = sP{i}{Solution(i)};
            for j = 2:length(path)
                roundTripDelay(i) = roundTripDelay(i) + 2 * D(path(j-1), path(j));
            end
        end
    end
end
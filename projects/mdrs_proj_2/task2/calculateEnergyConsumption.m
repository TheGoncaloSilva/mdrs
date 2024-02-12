function consumption= calculateEnergyConsumption(Lengths, Loads, T, sol, sP)
    % sP are the k shortest paths
    % sol is the solution with the computed shortest path
    consumption= 0;
    auxLoads= Loads';

    % Processing links
    for link=auxLoads
        if sum(link(3:4)) == 0 % Link in sleeping mode
            consumption= consumption + 2;
        else % Link in operation
            distance= Lengths(link(1), link(2));
            consumption= consumption + (9 + 0.3 * distance);
        end
    end

    % Processing nodes
    nNodes= length(Lengths);
    totalThroughput= zeros(nNodes,1);
    nFlows= height(T);
    capacity= 1000; % in Gbps

    for i= 1:nFlows
        if sol(i)>0
            path= sP{i}{sol(i)};
            throughput= T(i,3) + T(i,4); 
            for node=path
                totalThroughput(node,1) = totalThroughput(node,1) + throughput;
            end
        end
    end

    for i=1:length(totalThroughput(:,1))
        t = totalThroughput(i)/capacity;
        consumption = consumption + (20 + 80 * sqrt(t));
    end   

end
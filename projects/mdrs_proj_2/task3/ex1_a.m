% Exercise 1.a)
clear all
close all
clc

% Load input data
load('InputDataProject2.mat')

% Assuming T1 is the matrix for Service 1
T = [T1; T2];
nFlows = size(T, 1);

% Compute the propagation delay matrix D
v = 2e5; % speed of light on fibers in km/sec
D = L / v;

% Computing up to k=2 link disjoint paths for all flows
k = 2;
sP = cell(1, nFlows);
nSP = zeros(1, nFlows);

for f = 1:nFlows
    [shortestPath, totalCost] = kShortestPath(L, T(f, 1), T(f, 2), k);
    sP{f} = shortestPath;
    nSP(f) = length(totalCost);
end

% Check the feasibility by considering the load on nodes
sol = ones(1, nFlows); % All flows follow the shortest paths
[Loads, unusedLinks] = calculateLinkLoads(size(Nodes, 1), Links, T, sP, sol);

% Check if the solution is feasible
isFeasible = all(nSP >= 2) && all(all(Loads(:, 3:4) <= 1000));

% Check if node loads are within capacity
nodeLoads = sum(Loads(:, 3:4), 1); % Sum of loads for each node
isFeasible = isFeasible && all(nodeLoads <= 1000);

% Display the results
if isFeasible
    fprintf('The solution exists:\n');
    for f = 1:nFlows
        fprintf('\- tFlow %d (%d -> %d): Paths = ', f, T(f, 1), T(f, 2));
        for p = 1:k
            fprintf('%s ', num2str(sP{f}{p}));
        end
        fprintf('\n');
    end
    fprintf("\n");
    
    % Calculate and display the worst link load
    worstLinkLoad = max(max(Loads(:, 3:4)));
    if worstLinkLoad <= 100 % max link capacity
        fprintf('The solution is feasible. All traffic flows within capacity\n');
    else
        fprintf('The solution is not feasible, since Worst Link Load of %.2f exceeds maximum link capacity of 100 Gbps\n', worstLinkLoad);
    end
    fprintf('\n');

    % Call the print_solution_stats function
    print_solution_stats(Loads, calculateNetworkEnergyConsumption(Loads, L, T, sol, sP), 0, 0, sol, sP, T1, T2, D);
else
    fprintf('The solution does not exist. Some flows are unreachable\n');
end

%% Exercise 3.a)
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

% Display the non-greedy results
if isFeasible
    for f = 1:nFlows
        fprintf('Flow %d (%d -> %d): Paths = ', f, T(f, 1), T(f, 2));
        for p = 1:k
            fprintf('%s ', num2str(sP{f}{p}));
        end
        fprintf('\n');
    end
    
    % Calculate and display the worst link load
    worstLinkLoad = max(max(Loads(:, 3:4)));
    

    % Multi-Start Hill Climbing
    fprintf('Multi-Start Hill Climbing with Greedy Randomized Results:\n');
    [bestSol, bestLoads, bestLoad, contador, somador, bestLoadTime] = multiStartHillClimbingGreedy2(sP, nSP, T, size(Nodes, 1), Links, D, 60);
    
    % Call the print_solution_stats function with energy consumption
    print_solution_stats(bestLoads, calculateNetworkEnergyConsumption(bestLoads, L, T, bestSol, sP), contador, bestLoadTime, bestSol, sP, T1, T2, D);

else
    fprintf('The solution is not feasible. Some flows may be unreachable or node loads exceed capacity.\n');
end



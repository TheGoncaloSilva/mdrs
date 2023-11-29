%% Exercise 9.B - Determine the number of routing paths provided by the network to each traffic flow.
%   Register the minimum and maximum number of routing paths and the corresponding
%   traffic flows.clear all
close all
clc

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

fprintf('Exercise 9.b:\n');
% Computing up to k=inf shortest paths for all flows from 1 to nFlows:
k= inf;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

% Compute the link loads using the first (shortest) path of each flow:
sol= ones(1,nFlows);
Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
% Determine the worst link load:
maxLoad= max(max(Loads(:,3:4)));

% Find and print flows with the minimum number of paths
minPaths = min(nSP);
fprintf('Minimum no. of paths= %d\n', minPaths);
minFlowIndices = find(nSP == minPaths); % get the flows with minimum paths
for flow = minFlowIndices
    fprintf('\tFlow %d (%d -> %d)\n', flow, sP{flow}{sol(flow)}(1), sP{flow}{sol(flow)}(end));
end

% Find and print flows with the maximum number of paths
maxPaths = max(nSP);
fprintf('\nMaximum no. of paths= %d\n', maxPaths);
maxFlowIndices = find(nSP == maxPaths); % get the flows with the highest paths
for flow = maxFlowIndices
    fprintf('\tFlow %d (%d -> %d)\n', flow, sP{flow}{sol(flow)}(1), sP{flow}{sol(flow)}(end));
end

%% Exercise 9.c - Run each of the 4 algorithms (A, B, C and D) considering 
%   a runtime limit of 5 seconds and all possible routing paths for each flow. 
%   Register the worst link load (W) of the best obtained solution, the total 
%   number of solutions (No. sol), the average worst link load value (Av. W) 
%   among all solutions and the running time (time) at which each algorithm 
%   has obtained its best solution. Analyze the results and take conclusions.
fprintf('\nExercise 9.c:\n');

% Computing up to k=inf shortest paths for all flows from 1 to nFlows:
k= inf;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

fprintf('Random algorithm (all possible paths):\n');
[~, ~, bestLoad, contador, somador, bestLoadTime] = randomStrategy(sP, nSP, T, nNodes, Links, 5);
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

fprintf('Greedy randomized (all possible paths):\n');
[~, ~, bestLoad, contador, somador, bestLoadTime] = greedyRandomizedStrategy(sP, nSP, T, nNodes, Links, 5);
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

fprintf('Multi start hill climbing with random (all possible paths):\n');
[~, ~, bestLoad, contador, somador, bestLoadTime] = multiStartHillClimbingRandom(sP, nSP, T, nNodes, Links, 5);
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

fprintf('Multi start hill climbing with greedy randomized (all possible paths):\n');
[~, ~, bestLoad, contador, somador, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, 5);
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

% Conclusion: The results indicate that while the random algorithm explores 
%   a vast solution space, it incurs higher worst link loads compared to 
%   the more efficient greedy approaches—specifically, the greedy 
%   randomized and multi-start hill climbing with greedy randomized, which 
%   exploit initial solutions more effectively, resulting in lower worst 
%   link loads within a specified runtime limit.


%% Exercise 9.d. - Run each of the 4 algorithms considering a runtime 
%   limit of 5 seconds and the 6 shortest routing paths for each flow. 
%   Register the worst link load (W) of the best obtained solution, the 
%   total number of solutions (No. sol), the average worst link load value 
%   (Av. W) among all solutions and the running time (time) at which each   
%   algorithm has obtained its best solution. Analyze these results, 
%   compare with the previous results obtained in 9.c and take conclusions.
fprintf('\nExercise 9.d:\n');

% Computing up to k=6 shortest paths for all flows from 1 to nFlows:
k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

fprintf('Random algorithm (all possible paths):\n');
[~, ~, bestLoad, contador, somador, bestLoadTime] = randomStrategy(sP, nSP, T, nNodes, Links, 5);
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

fprintf('Greedy randomized (all possible paths):\n');
[~, ~, bestLoad, contador, somador, bestLoadTime] = greedyRandomizedStrategy(sP, nSP, T, nNodes, Links, 5);
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

fprintf('Multi start hill climbing with random (all possible paths):\n');
[~, ~, bestLoad, contador, somador, bestLoadTime] = multiStartHillClimbingRandom(sP, nSP, T, nNodes, Links, 5);
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

fprintf('Multi start hill climbing with greedy randomized (all possible paths):\n');
[~, ~, bestLoad, contador, somador, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, 5);
fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

% Conclusion: Results show that the random algorithm, exploring a wider 
%   solution space, yields a higher worst link load of 7.20 Gbps compared 
%   to the more efficient greedy approaches—greedy randomized and 
%   multi-start hill climbing with random—with a similar worst link load 
%   of 6.70 Gbps, exploiting initial solutions more effectively within 
%   shorter runtimes of 0.01 to 1.69 seconds, ultimately leading to lower 
%   average worst link loads.

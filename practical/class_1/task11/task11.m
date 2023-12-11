%% Exercise 11.a - Develop a Multi Start Hill Climbing algorithm with 
%   initial Greedy Randomized solutions to solve this optimization problem 
%   (use algorithm D of Task 9 as starting point). Computing up to k=4 
%   shortest paths for all flows from 1 to nFlows:

%% Exercise 11.b - Run the algorithm considering α = 1, a runtime limit of 
%   15 seconds and all possible routing paths for each flow. Register the 
%   energy consumption (E), the worst link load (W), the total number of 
%   solutions (No. sol), the running time (time) at which the algorithm has
%   obtained the best solution and the list of links in sleeping mode of 
%   the best solution.
close all
clc
clear

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

fprintf('Exercise 11.b:\n');

% Computing up to k=inf link disjoint paths
%   for all flows from 1 to nFlows:
k= inf;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end
% sP{f}{i} is the i-th path of flow f
% nSP(f) is the number of paths of flow f

runtimeLimint= 15;
alpha= 0.8;
[~, Loads, energy, contador, ~, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, runtimeLimint, alpha, L, C);
fprintf('E = %.2f\tW = %.2f Gbps\tNo. sols = %d\ttime = %.2f\n', energy, max(max(Loads(:,3:4))), contador, bestLoadTime);

fprintf('List of links in sleeping mode: ');
for i = 1:length(Loads)
    if sum(Loads(i, 3:4)) == 0
        fprintf('{%d,%d} ', Loads(i,1), Loads(i,2));
    end
end
fprintf('\n');

%% Exercise 11.c - Run the algorithm considering α = 1, a runtime limit of 
%   15 seconds and the 6 shortest routing paths for each flow. Register the 
%   same parameters as before. Compare these results with the results 
%   obtained in 11.b and take conclusions.
fprintf('Exercise 11.c:\n');

% Computing up to k=6 link disjoint paths
%   for all flows from 1 to nFlows:
k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end
% sP{f}{i} is the i-th path of flow f
% nSP(f) is the number of paths of flow f

runtimeLimint= 15;
alpha= 0.8;
[~, Loads, energy, contador, ~, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, runtimeLimint, alpha, L, C);
fprintf('E = %.2f\tW = %.2f Gbps\tNo. sols = %d\ttime = %.2f\n', energy, max(max(Loads(:,3:4))), contador, bestLoadTime);

fprintf('List of links in sleeping mode: ');
for i = 1:length(Loads)
    if sum(Loads(i, 3:4)) == 0
        fprintf('{%d,%d} ', Loads(i,1), Loads(i,2));
    end
end
fprintf('\n');

%% Exercise 11.d - Run the algorithm considering α = 0.8, a runtime limit 
%   of 15 seconds and all possible routing paths for each flow. Register 
%   the same parameters as before.
fprintf('Exercise 11.d:\n');

% Computing up to k=inf link disjoint paths
%   for all flows from 1 to nFlows:
k= inf;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end
% sP{f}{i} is the i-th path of flow f
% nSP(f) is the number of paths of flow f

runtimeLimint= 15;
alpha= 0.8;
[~, Loads, energy, contador, ~, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, runtimeLimint, alpha, L, C);
fprintf('E = %.2f\tW = %.2f Gbps\tNo. sols = %d\ttime = %.2f\n', energy, max(max(Loads(:,3:4))), contador, bestLoadTime);

fprintf('List of links in sleeping mode: ');
for i = 1:length(Loads)
    if sum(Loads(i, 3:4)) == 0
        fprintf('{%d,%d} ', Loads(i,1), Loads(i,2));
    end
end
fprintf('\n');

%% Exercise 11.e - Run the algorithm considering α = 0.8, a runtime limit 
%   of 15 seconds and the 6 shortest routing paths for each flow. Register 
%   the same parameters as before. Compare these results with the results 
%   obtained in 11.b, 11.c and 11.d and take conclusions.
fprintf('Exercise 11.e:\n');

% Computing up to k=6 link disjoint paths
%   for all flows from 1 to nFlows:
k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end
% sP{f}{i} is the i-th path of flow f
% nSP(f) is the number of paths of flow f

runtimeLimint= 15;
alpha= 0.8;
[~, Loads, energy, contador, ~, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, runtimeLimint, alpha, L, C);
fprintf('E = %.2f\tW = %.2f Gbps\tNo. sols = %d\ttime = %.2f\n', energy, max(max(Loads(:,3:4))), contador, bestLoadTime);
fprintf('List of links in sleeping mode: ');
for i = 1:length(Loads)
    if sum(Loads(i, 3:4)) == 0
        fprintf('{%d,%d} ', Loads(i,1), Loads(i,2));
    end
end
fprintf('\n');


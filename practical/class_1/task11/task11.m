%% Exercise 11.a - Develop a Multi Start Hill Climbing algorithm with 
%   initial Greedy Randomized solutions to solve this optimization problem 
%   (use algorithm D of Task 9 as starting point). Computing up to k=4 
%   shortest paths for all flows from 1 to nFlows:
close all
clc
clear

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

fprintf('Exercise 11.a:\n');

MTTR= 24;
CC= 450;
MTBF= (CC*365*24)./L;
A= MTBF./(MTBF + MTTR);
A(isnan(A))= 1;
Alog= -log(A);

% Computing up to k=4 link disjoint paths
%   for all flows from 1 to nFlows:
k= inf;
alpha= 1;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

[sol, Loads, energy, contador, somador, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, 5, alpha, L, C);
fprintf('E = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', energy, contador, somador/contador, bestLoadTime);

% Find and print flows with the minimum number of paths
minPaths = min(nSP);
fprintf('Minimum no. of paths= %d\n', minPaths);
minFlowIndices = find(nSP == minPaths); % get the flows with minimum paths
for flow = minFlowIndices
    fprintf('\tFlow %d (%d -> %d)\n', flow, sP{flow}{sol(flow)}(1), sP{flow}{sol(flow)}(end));
end

% Determine the worst link load:
maxLoad= max(max(Loads(:,3:4)));
bandwith= sum(sum(Loads(:,3:4)));
fprintf('Worst bandwidth capacity = %.1f Gbps\n', maxLoad);
fprintf('Total bandwidth capacity on all links = %.1f Gbps\n', bandwith);

fprintf('Paths that can be put on sleep mode\n');
for i= 1:nLinks
    % This calculations are the same as using indexing in a bidimensional
    % table (x,y) = x+y
    fprintf('{%2d - %2d}:\t%.2f\t%.2f\n', Loads(i), Loads(i+length(Loads)), Loads(i+length(Loads)*2), Loads(i+length(Loads)*3))
end

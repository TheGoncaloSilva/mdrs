%% Exercise 8.a - Determine the shortest path provided by the network to each traffic flow. 
%   Present the length and the sequence of nodes of each path
clear all
close all
clc

load('InputData.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

% Plotting network in figure 10:
%plotGraph(Nodes,Links,10);

% Computing up to k=6 shortest paths for all flows from 1 to nFlows:
k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
costs= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),1);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
    costs(f)= totalCost;
end

% sP{f}{i} is the i-th path of flow f
% nSP(f) is the number of paths of flow f

% Visualizing the best path of each flow:
for f= 1:nFlows
    fprintf('Flow %d (%d -> %d): length = %d, Path =  %s\n',f,T(f,1),T(f,2),costs(f),num2str(sP{f}{1}));
end

%% Exercise 8.b - Determine the link loads of all links when all traffic flows are routed through the shortest
%   path provided by the network. Determine also the worst link load
fprintf('\nExercise 8.b:\n');
% Compute the link loads using the first (shortest) path of each flow:
sol= ones(1,nFlows);
Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
% Determine the worst link load:
maxLoad= max(max(Loads(:,3:4)));

%Optimization algorithm based on random strategy:
t= tic;
timeLimit= 5;
bestLoad= inf;  % objective function value
contador= 0;
somador= 0;
while toc(t) < timeLimit
    sol= zeros(1,nFlows);
    for f= 1:nFlows
        sol(f)= randi(nSP(f));
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));   % calculate max capacity of link loads
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
        bestLoads= Loads;
    end
    contador= contador+1;
    somador= somador+load;
end
%Output of link loads of the routing solution:
fprintf('Worst link load of the best solution = %.2f\n',bestLoad);
fprintf('Link loads of the best solution:\n')
for i= 1:nLinks
    fprintf('{%d-%d}:\t%.2f\t%.2f\n',bestLoads(i,1),bestLoads(i,2),bestLoads(i,3),bestLoads(i,4))
end

%% Exercise 8.c - Determine the k = 4 shortest paths provided by the network for traffic flow 1. 
%   Present the length and the sequence of nodes of each path.
fprintf('\nExercise 8.c:\n');

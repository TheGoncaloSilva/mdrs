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
k= 1;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
costs= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
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
timeLimit= 5;   % in seconds
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
% Computing k=10 shortest paths for flow f= 4:
k= 4;
f= 1;
[shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);

% Visualizing the 6th path and its length:
for i=1:k
    fprintf('Path %d:  %s  (length = %.0f)\n',i,num2str(shortestPath{i}),totalCost(i));
end

%% Exercise 8.d - Consider the determination of a symmetrical single routing path solution with minimum
%   worst link load. Run the provided optimization algorithm based on the random strategy.
%   Consider a runtime limit of 5 seconds and all possible routing paths for each flow. Display
%   the assigned routing paths, the resulting link loads, and the performance parameters of the
%   algorithm. Compare the worst link load values of this solution and the solution of 8.b.
fprintf('\nExercise 8.d:\n');

% Computing up to k=6 shortest paths for all flows from 1 to nFlows:
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

%Optimization algorithm based on random strategy:
t= tic;
timeLimit= 5;   % in seconds
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

% Conclsuion: The link load is better in this exercise because the random
%   strategy is selecting from all available paths (k=inf) whereas before 
%   was selecting from only one path (k=1)

%% Exercise 8.e - Repeat task 8.d but now considering only 6 candidate routing 
%   paths for each flow. Compare these results with the ones obtained in task 8.d.
fprintf('\nExercise 8.e:\n');

% Computing up to k=6 shortest paths for all flows from 1 to nFlows:
k= 6;
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

%Optimization algorithm based on random strategy:
t= tic;
timeLimit= 5;   % in seconds
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
fprintf('Solutions considered: %d\n', contador);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);

% Conclusion: Limiting the k=6 will force the program to use the same 5
%   seconds to focus on a region of possible best solutions. This doesn't
%   mean that we are achieving the best possible solution, but in this way
%   we improve overall solutions.

%% Exercise 8.f - Use the provided optimization algorithm (based on the 
%   random strategy) to develop an optimization algorithm based on a greedy 
%   randomized strategy -> done in function greedyRandomizedStrategy

%% Exercise 8.g - Run the optimization algorithm based on the greedy 
%   randomized strategy (developed in 8.f) with a runtime limit of 5 
%   seconds and considering all possible routing paths for each flow. 
%   Compare these results with the ones obtained in tasks 8.d and 8.e.
fprintf('\nExercise 8.g:\n');

% Computing up to k=6 shortest paths for all flows from 1 to nFlows:
k= inf;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

[bestSol, bestLoads, bestLoad, contador, somador, ~] = greedyRandomizedStrategy(sP, nSP, T, nNodes, Links, 5);

%Output of link loads of the routing solution:
fprintf('Worst link load of the best solution = %.2f\n',bestLoad);
fprintf('Solutions considered: %d\n', contador);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);

% Conclusion: Althought the Worst link load didn't improve, the greedy 
%   randomized strategy analized fewer solutions, but outputted best avg
%   worst link load among all solutions, indicating that having more
%   computing power and reducing the time limit, could lead to generating 
%   equal or better solutions than the complete randomized approach 

%% Exercise 8.h - Repeat task 8.g but now considering only 6 candidate 
%   routing paths for each flow. Compare these results with the ones 
%   obtained in tasks 8.d, 8.e and 8.g.
fprintf('\nExercise 8.h:\n');

% Computing up to k=6 shortest paths for all flows from 1 to nFlows:
k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

[bestSol, bestLoads, bestLoad, contador, somador,~] = greedyRandomizedStrategy(sP, nSP, T, nNodes, Links, 5);

%Output of link loads of the routing solution:
fprintf('Worst link load of the best solution = %.2f\n',bestLoad);
fprintf('Solutions considered: %d\n', contador);
fprintf('Avg. worst link load among all solutions= %.2f\n',somador/contador);

% Conclusion: Reducing the set of solutions to 6 did not show an
%   improvement the worst link load, it in fact did worse, by considering
%   more solutions and having an average worst link load in all of them
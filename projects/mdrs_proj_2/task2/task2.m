%% Exercise 2.a - Consider now the optimization problem of computing a 
%   symmetrical single path routing solution to support both services which 
%   aims to minimize the energy consumption of the network. Adapt the 
%   algorithm developed in task 1.b to address this optimization problem

%% Exercise 2.b - Run the algorithm developed in task 2.a for 60 seconds 
%   with k = 2. Concerning the best obtained solution, register the same 
%   values that were also requested before.
close all
clc
clear

load('InputDataProject2.mat')

nNodes= size(Nodes,1);
nLinks= size(Links,1);
T= [T1; T2];
nFlows= size(T,1);
v= 2*10^5;
D= L/v;

fprintf('Exercise 2.b:\n');

% Computing up to k=2 link disjoint paths
%   for all flows from 1 to nFlows:
k= 2;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end
% sP{f}{i} is the i-th path of flow f
% nSP(f) is the number of paths of flow f

runtimeLimint= 60;
alpha= 1; % support max link load
C= 100; % Link capacity per direction
[sol, Loads, energy, contador, ~, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, runtimeLimint, alpha, L, C);

print_solution_stats(Loads, energy, contador, bestLoadTime, sol, sP, T1, T2, D);

%% Exercise 2.c - Run again the algorithm developed in task 2.a for 60 
%   seconds but now with k = 6. Concerning the best obtained solution, 
%   register the same values that were also requested
fprintf('\nExercise 2.c:\n');

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

runtimeLimint= 60;
alpha= 1;   % support max link load
[sol, Loads, energy, contador, ~, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, runtimeLimint, alpha, L, C);

print_solution_stats(Loads, energy, contador, bestLoadTime, sol, sP, T1, T2, D)

%% Print_solution_stats function
function print_solution_stats(Loads, energy, contador, bestLoadTime, sol, sP, T1, T2, D)
fprintf("Solution stats: \n");

maxLoad= max(max(Loads(:,3:4)));
fprintf(" - Worst link load: %.2f Gbps\n", maxLoad);

averageLinkLoad= mean(Loads(:,3:4));
fprintf(" - Average Upload link load: %.2f Gbps\n", averageLinkLoad(1));
fprintf(" - Average Download link load: %.2f Gbps\n", averageLinkLoad(2));

fprintf(" - Network energy consumption: %.2f\n", energy);

% Value per service
service1Count= 0;
service2Count= 0;
for i=1:length(sol)
    % get path of the solution
    path= sP{i}{sol(i)};

    % calculate path delay
    delay= 0;
    for ii=1:(length(path)-1)
        delay = delay + D(path(ii), path(ii+1));
    end

    if i <= length(T1) % service 1
        service1Count= service1Count + delay;
    else % service 2
        service2Count= service2Count + delay;
    end
end

fprintf(" - Average Round trip time:\n");
service1RTT= service1Count/length(T1);
fprintf(" \t- Service 1: %.3f ms\n", service1RTT * 2 * 1000);
service2RTT= service2Count/length(T2);
fprintf(" \t- Service 2: %.3f ms\n", service2RTT * 2 * 1000);

fprintf(" - Nº of links without traffic: %d\n", max(sum(Loads(:, 3:4)==0)));
fprintf(' - Links with no traffic: ');
for i = 1:length(Loads)
    if sum(Loads(i, 3:4)) == 0
        fprintf('{%d,%d} ', Loads(i,1), Loads(i,2));
    end
end
fprintf('\n');

fprintf(" - Number of cycles: %d\n", contador);

fprintf(" - Best solution time: %.2f\n", bestLoadTime);

fprintf("\n");

end
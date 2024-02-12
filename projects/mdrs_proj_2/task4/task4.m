%% Exercise 4.a - Consider the optimization problem of computing a 
%   symmetrical single path routing solution to support all services which 
%   aims to minimize the energy consumption of the network (this problem is 
%   similar with the one addressed in Task 2 but now the network also 
%   supports the anycast service). Adapt the algorithm developed in task 
%   2.a to address this optimization problem


%% Exercise 4.b - Run the algorithm developed in task 4.a for 60 seconds with 
%   k = 6 for the unicast flows. Concerning the best obtained solution, 
%   register the same values that were also requested before 
%   (in the case of the average round-trip propagation delay, you now
%   need to register this value for each of the 3 services)
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
anycastNodes= [3; 10];

fprintf('Exercise 4.b:\n');

% Computing up to k=6 link disjoint paths for all unicast flows:
k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

% Computing up to k=6 link disjoint paths for all anycast flows
sourceAnycastNodes= T3(:,1);
[costs, tempsP, tempnSP]= anycastDestination(sourceAnycastNodes, anycastNodes, D, k);

% Integrate anycast flows paths and counts into sP and nSP, after unicast
dupT3= zeros(size(T3));
for i = 1:length(tempsP)
    sP{nFlows + i} = tempsP{i};
    nSP(nFlows + i) = tempnSP(i);
    % Get destination anycast node
    tempPath= tempsP{i}{1};
    dest= tempPath(length(tempPath));
    % change T3
    dupT3(i,1)= T3(i,1);
    dupT3(i,2)= dest;
    dupT3(i,3)= T3(i,2);
    dupT3(i,4)= T3(i,3);
end

% join unicast and anycast flows
T= [T; dupT3];
nFlows= size(T,1);

runtimeLimint= 60;
alpha= 1; % support max link load
C= 100; % Link capacity per direction
[sol, Loads, energy, contador, ~, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, runtimeLimint, alpha, L, C);

print_solution_stats(Loads, energy, contador, bestLoadTime, sol, sP, T1, T2, dupT3, D);


%% Exercise 4.c - Consider now that you can freely select the 2 anycast nodes 
%   of the anycast service. Try all possible combinations of 2 nodes and 
%   register the combination that minimizes the average round-trip 
%   propagation delay of the anycast service.

fprintf('\nExercise 4.c:\n');
combsAnycastSources= nchoosek(1:nNodes, 2);

% Initialization
k= 6;
bestWorstCost= inf;
bestAnycastNodes= combsAnycastSources(1, :); % initialize with the first pair
bestSP= cell(1, length(sourceAnycastNodes));
bestnSP= zeros(1, size(T3,1));

% Loop through combinations
for i = 1:size(combsAnycastSources,1)
    anycastNodes= combsAnycastSources(i, :);
    
    % Test combination of nodes
    [costs, tempsP, tempnSP]= anycastDestination(sourceAnycastNodes, anycastNodes, D, k);
    cost = sum(sum(costs));

    % Update best values if better result is found
    % and exclude anycast destination nodes originating in source nodes
    if cost < bestWorstCost % && (min(min(costs)) > 0)
        bestWorstCost= cost;
        bestAnycastNodes= anycastNodes;
        bestSP= tempsP;
        bestnSP= tempnSP;
    end
end

fprintf("Best Node combination: {%d, %d}\n", bestAnycastNodes);


%% Exercise 4.d - Repeat task 4.b but now considering as anycast nodes the 
%   combination computed in the previous task 4.c. Concerning the best 
%   obtained solution, register the same values that were also requested 
%   before.

fprintf('\nExercise 4.d:\n');

% Computing up to k=6 link disjoint paths for all unicast flows:
T= [T1; T2];
nFlows= size(T,1);

k= 6;
sP= cell(1,nFlows);
nSP= zeros(1,nFlows);
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

% Integrate anycast flows paths and counts into sP and nSP, after unicast
dupT3= zeros(1);
aux= 1;
for i = 1:length(bestSP)
    if ~isempty(bestSP{i})
        sP{nFlows + aux} = bestSP{i};
        nSP(nFlows + aux) = bestnSP(i);

        % Get destination anycast node
        tempPath= bestSP{i}{1};
        dest= tempPath(length(tempPath));
    
        % change T3
        dupT3(aux,1)= T3(i,1);
        dupT3(aux,2)= dest;
        dupT3(aux,3)= T3(i,2);
        dupT3(aux,4)= T3(i,3);

        aux = aux + 1;
    end
end

% join unicast and anycast flows
T= [T; dupT3];
nFlows= size(T,1);

runtimeLimint= 60;
alpha= 1; % support max link load
C= 100; % Link capacity per direction
[sol, Loads, energy, contador, ~, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, runtimeLimint, alpha, L, C);

% add the flows removed before, that have the same source and destination
% anycast node
numRowsT3 = size(T3, 1);
numRowsdupT3 = size(dupT3, 1);

if numRowsdupT3 < numRowsT3
    rowsToAdd = numRowsT3 - numRowsdupT3;
    
    % Append rows of zeros to matrix dupT3
    dupT3 = [dupT3; zeros(rowsToAdd, size(dupT3, 2))];
end

print_solution_stats(Loads, energy, contador, bestLoadTime, sol, sP, T1, T2, dupT3, D);


%% Print_solution_stats function
function print_solution_stats(Loads, energy, contador, bestLoadTime, sol, sP, T1, T2, T3, D)
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
service3Count= 0;
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
    elseif i <= (length(T1) + length(T2)) % service 2
        service2Count= service2Count + delay;
    else % service 3
        service3Count= service3Count + delay;
    end
end

fprintf(" - Average Round trip time:\n");
service1RTT= service1Count/length(T1);
fprintf(" \t- Service 1: %.3f ms\n", service1RTT * 2 * 1000);
service2RTT= service2Count/length(T2);
fprintf(" \t- Service 2: %.3f ms\n", service2RTT * 2 * 1000);
service3RTT= service3Count/length(T3);
fprintf(" \t- Service 3: %.3f ms\n", service3RTT * 2 * 1000);

fprintf(" - Nº of links without traffic: %d\n", max(sum(Loads(:, 3:4)==0)));
fprintf(' - Links without traffic: ');
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
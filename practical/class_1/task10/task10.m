%% Exercise 10.a - For each flow, compute the most available path (and its 
%   availability value)
close all
clc
clear

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

fprintf('Exercise 10.a:\n');

MTTR= 24;
CC= 450;
MTBF= (CC*365*24)./L;
A= MTBF./(MTBF + MTTR);
A(isnan(A))= 1;
Alog= -log(A);

% Computing up to k=1 pairs of link disjoint paths
% for all flows from 1 to nFlows:
k= 1;
sP= cell(2,nFlows);
nSP= zeros(2,nFlows);
availabilities= zeros(1,nFlows);% sP{1,f}{i} is the 1st path of the i-th path pair of flow f
% sP{2,f}{i} is the 2nd path of the i-th path pair of flow f
% nSP(f) is the number of path pairs of flow f

for f=1:nFlows
    % Total cost is the sum of each path -log value
    [shortestPath, totalCost] = kShortestPath(Alog,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
    availabilities(f)= exp(-totalCost);% use exp to inverse log% first node of the link
    for i= 1:nSP(f)
        Aaux= Alog;
        path1= sP{1,f}{i};
        for j=2:length(path1)
             % Place availability as infinite in the connections of the 1st
             %  route, this way, the next route can't use this connections
             %  Which means that two routes are disjunt and parallel
            Aaux(path1(j),path1(j-1))= inf;
            Aaux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Aaux,T(f,1),T(f,2),1);
        % If new route is found
        if ~isempty(shortestPath)
            sP{2,f}{i}= shortestPath{1};
        end
    end
end

% Visualizing the best path of each flow:
for f= 1:nFlows
    avail= availabilities(f);
    path= num2str(sP{1,f}{1});
    fprintf('Flow %2d: Availability= %.7f - Path =  %s\n',f,avail,path);
end

%% Exercise 10.b - Determine the average availability per flow when each 
%   flow is routed by the most available path computed in 10.a.

fprintf('Exercise 10.b:\n');
fprintf('Average availability=%.7f\n', mean(availabilities));

%% Exercise 10.c - Assume that the most available path (computed in 10.a) 
%   of each flow is its first routing path. For each flow, compute a second 
%   routing path (if exists) given by the most available path which is link 
%   disjoint with the previously computed first routing path. Determine the
%   availability of the routing solution of each flow. Is there always a 
%   second routing path for all flows? Why?
fprintf('Exercise 10.c:\n');
% Computing up to k=2 pairs of link disjoint paths
% for all flows from 1 to nFlows:
k= 1;
sP= cell(2,nFlows);
nSP= zeros(1,nFlows);
availabilities= zeros(2,nFlows);
avgAvailability= zeros(1,nFlows);
% sP{1,f}{i} is the 1st path of the i-th path pair of flow f
% sP{2,f}{i} is the 2nd path of the i-th path pair of flow f
% nSP(f) is the number of path pairs of flow f

for f=1:nFlows
    % Total cost is the sum of each path -log value
    [shortestPath, totalCost] = kShortestPath(Alog,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
    availabilities(1,f)= exp(-totalCost);% use exp to inverse log first node of the link
    for i= 1:nSP(f)
        Aaux= Alog;
        path1= sP{1,f}{i};
        for j=2:length(path1)
             % Place availability as infinite in the connections of the 1st
             %  route, this way, the next route can't use this connections
             %  Which means that two routes are disjunt and parallel
            Aaux(path1(j),path1(j-1))= inf;
            Aaux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Aaux,T(f,1),T(f,2),1);
        % If new route is found
        if ~isempty(shortestPath)
            sP{2,f}{i}= shortestPath{1};
            availabilities(2,f)= exp(-totalCost);% use exp to inverse log first node of the link   
        else
            availabilities(2,f)= 0;% use exp to inverse log first node of the link
        end
    end
end

% Visualizing the best path of each flow:
for f= 1:nFlows
    avail1= availabilities(1,f);
    avail2= availabilities(2,f);
    avgAvailability(f)= 1-(1-avail1)*(1-avail2);
    path1= num2str(sP{1,f}{1});
    if ~isempty(sP{2,f})
        path2= num2str(sP{2,f}{1});
    else 
        path2= '';
    end
    fprintf('Flow %2d: Availability= %.7f - Path =  %s\n',f,avgAvailability(f),path1);
    fprintf('\t\t\t\t - Path =  %s\n', path2);
end

% Conclusion: Not all flows have a second link-disjoint (doesn't share any 
%   common routing path with the first link) routing path, but that only 
%   depends on the network topology and computed cost

%% Exercise 10.d - Determine the average availability per flow when each 
%   flow is routed by the previous routing solution. Compare this value 
%   with the value obtained in 10.b and take conclusions.
fprintf('Exercise 10.d:\n');
fprintf('Average availability=%.7f\n', mean(avgAvailability));

% Conclusion: Since we two routing paths, meant that each flow had some
%   sort of redundancy, this increasing the average availability, comparing
%   to exercise 10.b

%% Exercise 10.e - Compute how much bandwidth capacity is required on each 
%   link to support all flows with 1+1 protection when each flow is routed 
%   by the routing solution of 10.c. Compute also the worst bandwidth 
%   capacity required among all links and the total bandwidth required in 
%   all links.
fprintf('Exercise 10.e:\n');

% Compute the link loads using the first (shortest) path of each flow with 1+1:
sol= ones(1,nFlows);
Loads= calculateLinkBand1plus1(nNodes,Links,T,sP,sol);
% Determine the worst link load:
maxLoad= max(max(Loads(:,3:4)));
bandwith= sum(sum(Loads(:,3:4)));

fprintf('Worst bandwidth capacity = %.1f Gbps\n', maxLoad);
fprintf('Total bandwidth capacity on all links = %.1f Gbps\n', bandwith);


for i= 1:nLinks
    fprintf('{%d - %d}:\t%.2f\t%.2f\n', Loads(i), Loads(i+length(Loads)), Loads(i+length(Loads)*2), Loads(i+length(Loads)*3))
end

%% Exercise 10.f - Compute how much bandwidth capacity is required on each 
%   link to support all flows with 1:1 protection when each flow is routed 
%   by the routing solution of 10.c. Compute also the worst bandwidth 
%   capacity required among all links and the total bandwidth required in 
%   all links. Compare these results with the results of 10.e and take 
%   conclusions
fprintf('Exercise 10.f:\n');

% Compute the link loads using the first (shortest) path of each flow with 1:1:
sol= ones(1,nFlows);
Loads= calculateLinkBand1to1(nNodes,Links,T,sP,sol);
% Determine the worst link load:
maxLoad= max(max(Loads(:,3:4)));
bandwith= sum(sum(Loads(:,3:4)));

fprintf('Worst bandwidth capacity = %.1f Gbps\n', maxLoad);
fprintf('Total bandwidth capacity on all links = %.1f Gbps\n', bandwith);


for i= 1:nLinks
    fprintf('{%d - %d}:\t%.2f\t%.2f\n', Loads(i), Loads(i+length(Loads)), Loads(i+length(Loads)*2), Loads(i+length(Loads)*3))
end

% Conclusion: For 1:1 protection, the worst bandwidth capacity required 
%   decreased slightly from 14.6 Gbps to 14.5 Gbps, while the total 
%   bandwidth capacity on all links decreased from 280.5 Gbps to 247.8
%   Gbps. This indicates that while the worst-case scenario didn't see a 
%   significant change in required bandwidth capacity between 1+1 and 1:1 
%   protection, the total bandwidth required across all links reduced 
%   notably with 1:1 protection. This is due to the shared links with
%   protection and service links, that can be shared by various flows
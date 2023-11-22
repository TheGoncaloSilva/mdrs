%% Exercise 10.a - For each flow, compute the most available path (and its 
%   availability value)
close all
clc

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
    path1= num2str(sP{1,f}{1});
    if ~isempty(sP{2,f})
        path2= num2str(sP{2,f}{1});
    else 
        path2= '';
    end
    fprintf('Flow %2d: Availability= %.7f - Path =  %s\n',f,1-(1-avail1)*(1-avail2),path1);
    fprintf('\t\t\t\t - Path =  %s\n', path2);
end

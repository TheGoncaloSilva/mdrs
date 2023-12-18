%% Exercise 12.a - Consider that the service is provided by two DCs, one 
%   connected to network node 3 and the other connected to network node 5 
%   (i.e., the anycast nodes are node 3 and node 5). Compute the worst 
%   round-trip delay (W) and the average round trip delay (A) among all 
%   clients, presenting both values in milliseconds. Compute also the 
%   network node whose clients suffer the worst round-trip delay.
close all
clc
clear

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

fprintf('Exercise 12.a:\n');

v= 2*10^5;    % km/sec
D= L/v;
throughput= [0.7 1.5 2.1 1.0 1.3 2.7 2.2 0.8 1.7 1.9 2.8;
                0.1 0.2 0.3 0.1 0.1 0.4 0.3 0.1 0.2 0.3 0.4];
anycastNodes= [3;5];

% sourceNodes are a collection of nodes that aren't designated as anycast
% nodes and are calculated by excluding anycast nodes from the set of nodes
sourceNodes = setdiff(1:nNodes, anycastNodes);

k = 1; % number of paths for each node
[costs, sP] = optimizePath(nNodes, anycastNodes, D, k);

fprintf("Anycast Nodes = %d %d\n", anycastNodes(1), anycastNodes(2));
[worstCost, worstNode] = max(costs);
fprintf("Node with the worst round-trip delay: %d\n", worstNode);
fprintf("W = %.2f ms A = %.2f ms\n\n", worstCost * 2 * 1000, mean(costs) * 2 * 1000);

%% Exercise 12.b - Consider again that the anycast nodes are node 3 and 
%   node 5. Determine the link loads of all links and the worst link load. 

fprintf('Exercise 12.b:\n');

T = zeros(height(sourceNodes), 4);
idx = 1;

% Iterate over paths
for p = sP
    if isempty(p{1})
        continue;
    end

    srcN = p{1}{1}(1);
    dstN = p{1}{1}(end);
    T(idx, 1) = srcN;
    T(idx, 2) = dstN;
    T(idx, 3) = throughput(2, srcN);
    T(idx, 4) = throughput(1, srcN);

    idx = idx + 1;
end

sol = ones(1, nNodes-length(anycastNodes));
sP = sP(~cellfun(@isempty, sP));    % remove empty entry from the cell array

Loads = calculateLinkLoads(nNodes, Links, T, sP, sol);

% Determine the worst link load:
maxLoad= max(max(Loads(:,3:4)));

fprintf("Anycast Nodes = %d %d\n", anycastNodes(1), anycastNodes(2));
fprintf('Worst link load = %.1f Gbps\n', maxLoad);
for i = 1:length(Loads)
    fprintf('{%2d,%2d}:\t %.2f %.2f \n', Loads(i,1), Loads(i,2), Loads(i,3), Loads(i,4));
end

%% Exercise 12.c - Consider that you can freely select the nodes to connect 
%   the two DCs running the service. Try all possible combinations of 2 
%   nodes and select the one that minimizes the worst round-trip delay. 
%   Indicate the two selected nodes, the worst round-trip delay, and the 
%   worst link load of the best solution. Compare these results with the 
%   results obtained for the anycast nodes 3 and 5 and take conclusions.

fprintf('Exercise 12.c:\n');



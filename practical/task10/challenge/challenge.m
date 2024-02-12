%% Challenge exercise - Maximize the number of paths with no load, which 
%   means number of links that can be put on sleep mode, based on k=4 and 
%   k=20. Develop this exercise with the multi start hill climbing greedy 
%   algorithm and with 1:1 protection

% Computing up to k=4 shortest paths for all flows from 1 to nFlows:
k= 4;
sP= cell(2,nFlows);
nSP= zeros(1,nFlows);
% sP{1,f}{i} is the 1st path of the i-th path pair of flow f
% sP{2,f}{i} is the 2nd path of the i-th path pair of flow f
% nSP(f) is the number of path pairs of flow f

for f=1:nFlows
    % Total cost is the sum of each path -log value
    [shortestPath, totalCost] = kShortestPath(Alog,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
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

[sol, Loads, bestLoad, contador, somador, bestLoadTime] = multiStartHillClimbingGreedy(sP, nSP, T, nNodes, Links, 5);
fprintf('W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);

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

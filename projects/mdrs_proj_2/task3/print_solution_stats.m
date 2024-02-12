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
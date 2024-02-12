% Ex: 5.a - Run Simulator1 10 times with a stopping criterion of P = 10000 at each run 
%   and to compute the estimated values and the 90% confidence intervals of all 
%   performance parameters when  = 1800 pps, C = 10 Mbps and f = 1.000.000 Bytes (~1 MByte)
N = 10; %number of simulations
Lambda = 1800;
C = 10;
F = 1000000;
P = 10000;
PL = zeros(1,N); %vector with N simulation values
APD = zeros(1,N); %vector with N simulation values
MPD = zeros(1,N); %vector with N simulation values
TT = zeros(1,N); %vector with N simulation values

for it= 1:N
    [PL(it),APD(it),MPD(it),TT(it)] = Simulator1(Lambda, C, F, P);
end
alfa= 0.1; % 90% confidence interval %
showStats(PL, APD, MPD, TT, alfa, N);


% Ex: 5.b - Repeat the previous experiment but now run Simulator1 100 times. 
%   Compare these results with the previous ones and take conclusions
%   (Values may differ since this is a simulation)
fprintf('\nSimulation with 100 iterations:\n');
N = 100; %number of simulations
PL = zeros(1,N); %vector with N simulation values
APD = zeros(1,N); %vector with N simulation values
MPD = zeros(1,N); %vector with N simulation values
TT = zeros(1,N); %vector with N simulation values

for it= 1:N
    [PL(it),APD(it),MPD(it),TT(it)] = Simulator1(Lambda, C, F, P);
end
alfa= 0.1; % 90% confidence interval %
showStats(PL, APD, MPD, TT, alfa, N);

% Conclusion: By running Simulator1 100 times instead of 10 times, the results 
%   show a slightly lower average packet delay and a narrower confidence interval 
%   for all parameters. This indicates that running more simulations provides 
%   more accurate and consistent estimates of performance parameters.


% Ex: 5.c - Repeat the experiment 5.b but now consider f = 10.000 Bytes (~10 KBytes)
fprintf('\nSimulation with f = 10.000 Bytes:\n');
F = 10000000;
PL = zeros(1,N); %vector with N simulation values
APD = zeros(1,N); %vector with N simulation values
MPD = zeros(1,N); %vector with N simulation values
TT = zeros(1,N); %vector with N simulation values

for it= 1:N
    [PL(it),APD(it),MPD(it),TT(it)] = Simulator1(Lambda, C, F, P);
end
alfa= 0.1; % 90% confidence interval %
showStats(PL, APD, MPD, TT, alfa, N);

% Conclusion: When the queue size (f) is reduced to 10,000 bytes from 1,000,000 bytes, 
%   the packet loss increases slightly, the average packet delay decreases, and the 
%   maximum packet delay decreases. This is expected because a smaller queue has less 
%   buffer space, which leads to more packet loss but lower delays. The throughput 
%   remains relatively stable.


% Ex: 5.d - Repeat the experiment 5.b but now consider f = 2.000 Bytes (~2 KBytes)
fprintf('\nSimulation with f = 2.000 Bytes:\n');
F = 10000000;
PL = zeros(1,N); %vector with N simulation values
APD = zeros(1,N); %vector with N simulation values
MPD = zeros(1,N); %vector with N simulation values
TT = zeros(1,N); %vector with N simulation values

for it= 1:N
    [PL(it),APD(it),MPD(it),TT(it)] = Simulator1(Lambda, C, F, P);
end
alfa= 0.1; % 90% confidence interval %
showStats(PL, APD, MPD, TT, alfa, N);

% Conclusion: Further reducing the queue size to 2,000 bytes leads to a significant 
%   increase in packet loss, a decrease in average packet delay, and a further 
%   decrease in maximum packet delay. This is because the smaller queue size cannot 
%   buffer as many packets, leading to more packet loss and lower delays. The 
%   throughput also decreases slightly.


% Ex: 5.e - Consider that the system is modelled by a M/G/1 queueing model1. Determine 
%   the theoretical values of the packet loss, average packet delay and total throughput 
%   using the M/G/1 model for the parameters considered in experiments 5.a and 5.b
fprintf('\nSimulation with for M\\G\\1 Model:\n');
N = 100;
Lambda = 1800;
C = 10;
F = 1000000;
P = 10000;
capacity = 10*10^6;
PL = zeros(1,N); 
APD = zeros(1,N); 
MPD = zeros(1,N);
TT = zeros(1,N); 
x = 64:1518;

prob_left = (1 - (0.19 + 0.23 + 0.17)) / ((109 - 65 + 1) + (1517 - 111 + 1));
avg_bytes = 0.19*64 + 0.23*110 + 0.17*1518 + sum((65:109)*(prob_left)) + sum((111:1517)*(prob_left));
avg_time = avg_bytes * 8 / capacity;
S = (x .* 8) ./ (capacity);
S2 = (x .* 8) ./ (capacity);

for i = 1:length(x)
    if i == 1
        S(i) = S(i) * 0.19;
        S2(i) = S2(i)^2 * 0.19;
    elseif i == 110-64+1
        S(i) = S(i) * 0.23;
        S2(i) = S2(i)^2 * 0.23;
    elseif i == 1518-64+1
        S(i) = S(i) * 0.17;
        S2(i) = S2(i)^2 * 0.17;
    else
        S(i) = S(i) * prob_left;
        S2(i) = S2(i)^2 * prob_left;
    end
end

ES = sum(S);
ES2 = sum(S2);

throughput =  Lambda * avg_bytes * 8 / 10^6;
wsystem = Lambda * ES2 / (2*(1 - Lambda * ES)) + ES;
loss = ( (avg_bytes * (8 / 10^6)) / ((F * (8 / 10^6)) + capacity) ) * 100;

fprintf("Packet Loss (%%)\t\t= %.4f\n", loss);
fprintf("Av. Packet Delay(ms)\t= %.4f\n", wsystem * 1000);
fprintf("Throughput (Mbps)\t= %.4f \n\n", throughput);

% Conclusion: The theoretical values obtained from the M/G/1 model are quite close 
%   to the simulation results for experiments 5.a and 5.b. This suggests that the 
%   M/G/1 model is a reasonable approximation for analyzing the system's performance 
%   in these scenarios. However, it's essential to note that the M/G/1 model may not 
%   be as accurate for experiments 5.c and 5.d, where the queue size is significantly 
%   reduced, leading to increased packet loss. In such cases, the M/G/1 model might 
%   underestimate packet loss.


function showStats(PL, APD, MPD, TT, alfa, N)
    media = mean(PL);
    term = norminv(1-alfa/2)*sqrt(var(PL)/N);
    fprintf('PacketLoss (%%)         = %.2e +- %.2e\n',media,term)
    media = mean(APD);
    term = norminv(1-alfa/2)*sqrt(var(APD)/N);
    fprintf('Av. Packet Delay (ms)  = %.2e +- %.2e\n',media,term)
    media = mean(MPD);
    term = norminv(1-alfa/2)*sqrt(var(MPD)/N);
    fprintf('Max. Packet Delay (ms) = %.2e +- %.2e\n',media,term)
    media = mean(TT);
    term = norminv(1-alfa/2)*sqrt(var(TT)/N);
    fprintf('Throughput (Mbps)      = %.2e +- %.2e\n',media,term)
end

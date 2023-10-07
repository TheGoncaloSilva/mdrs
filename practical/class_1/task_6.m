% Ex: 6.b - Run Simulator2 100 times with a stopping criterion of P = 10000 
%   at each run and to compute the estimated values and the 90% confidence 
%   intervals of all performance parameters when k = 1800 pps, C = 10 Mbps, 
%   f = 1.000.000 Bytes (~1MByte) and b = 10e-6
N = 100;
Lambda = 1800;
C = 10;
F = 1000000;
P = 10000;
B = 10e-6;
PL = zeros(1,N); %vector with N simulation values
APD = zeros(1,N); %vector with N simulation values
MPD = zeros(1,N); %vector with N simulation values
TT = zeros(1,N); %vector with N simulation values

for it= 1:N
    [PL(it),APD(it),MPD(it),TT(it)] = Simulator2(Lambda, C, F, P, B);
end
alfa= 0.1; % 90% confidence interval %
showStats(PL, APD, MPD, TT, alfa, N);

% Conclusion: Introducing bit errors with a BER of 1e-6 in a wireless 
%   access network causes a small but measurable increase in packet loss, 
%   average packet delay, and maximum packet delay. Additionally, it 
%   slightly reduces throughput compared to a scenario with no bit errors 
%   (Experiment 5.b).


% Ex: 6.c - Repeat the experiment 6.b but now consider f = 10.000 Bytes 
%   (~10 KBytes)
fprintf('\nSimulation with f = 10.000 Bytes:\n');
F = 10000;
PL = zeros(1,N); %vector with N simulation values
APD = zeros(1,N); %vector with N simulation values
MPD = zeros(1,N); %vector with N simulation values
TT = zeros(1,N); %vector with N simulation values

for it= 1:N
    [PL(it),APD(it),MPD(it),TT(it)] = Simulator2(Lambda, C, F, P, B);
end
alfa= 0.1; % 90% confidence interval %
showStats(PL, APD, MPD, TT, alfa, N);

% Conclusion: Reducing the queue size to 10,000 Bytes while maintaining a 
%   bit error rate (BER) of 1e-6 in a wireless access network increases 
%   packet loss but maintains a similar average and maximum packet delay. 
%   Throughput is slightly lower due to increased packet losses.


% Ex: 6.d - Repeat the experiment 6.c but now consider f = 2.000 Bytes 
%   (~2 KBytes)
fprintf('\nSimulation with f = 2.000 Bytes:\n');
F = 10000;
PL = zeros(1,N); %vector with N simulation values
APD = zeros(1,N); %vector with N simulation values
MPD = zeros(1,N); %vector with N simulation values
TT = zeros(1,N); %vector with N simulation values

for it= 1:N
    [PL(it),APD(it),MPD(it),TT(it)] = Simulator2(Lambda, C, F, P, B);
end
alfa= 0.1; % 90% confidence interval %
showStats(PL, APD, MPD, TT, alfa, N);

% Conclusion: A small queue size of 2,000 Bytes with a bit error rate (BER) 
%   of 1e-6 in a wireless access network significantly increases packet 
%   loss but reduces average and maximum packet delays compared to 
%   Experiment 5.d. Throughput is lower due to the combination of small 
%   queue size and bit errors.


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
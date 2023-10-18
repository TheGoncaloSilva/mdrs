% Ex: 7.b - Develop a MATLAB script to run Simulator3 100 times with a 
%   stopping criterion of P = 10000 at each run and to compute the 
%   estimated values and the 90% confidence intervals of all performance 
%   parameters when k = 1800 pps, C = 10 Mbps, f = 1.000.000 Bytes 
%   (~1MByte) and n = 20.
iter = 100;
Lambda = 1800;
C = 10;
F = 1000000;
P = 10000;
n = 20;
PLdata = zeros(1,iter); %vector with N simulation values
PLvoip = zeros(1,iter); %vector with N simulation values
APDdata = zeros(1,iter); %vector with N simulation values
APDvoip = zeros(1,iter); %vector with N simulation values
MPDdata = zeros(1,iter); %vector with N simulation values
MPDvoip = zeros(1,iter); %vector with N simulation values
TT = zeros(1,iter); %vector with N simulation values

for it= 1:iter
    [PLdata(it),PLvoip(it),APDdata(it),APDvoip(it),MPDdata(it),MPDvoip(it),TT(it)] = Simulator3(Lambda, C, F, P, n);
end
alfa= 0.1; % 90% confidence interval %
showStats(PLdata, PLvoip, APDdata, APDvoip, MPDdata, MPDvoip, TT, alfa, iter);


% Ex: 7.c - Repeat the experiment 7.b but now consider f = 10.000 Bytes 
%   (~10 KBytes) Justify the differences between these results and the 
%   results of experiment.
fprintf('\nSimulation with f = 10.000 Bytes:\n');
F = 10000;
PLdata = zeros(1,iter); %vector with N simulation values
PLvoip = zeros(1,iter); %vector with N simulation values
APDdata = zeros(1,iter); %vector with N simulation values
APDvoip = zeros(1,iter); %vector with N simulation values
MPDdata = zeros(1,iter); %vector with N simulation values
MPDvoip = zeros(1,iter); %vector with N simulation values
TT = zeros(1,iter); %vector with N simulation values

for it= 1:iter
    [PLdata(it),PLvoip(it),APDdata(it),APDvoip(it),MPDdata(it),MPDvoip(it),TT(it)] = Simulator3(Lambda, C, F, P, n);
end
alfa= 0.1; % 90% confidence interval %
showStats(PLdata, PLvoip, APDdata, APDvoip, MPDdata, MPDvoip, TT, alfa, iter);

% Conclusion: Reducing the queue size to 10,000 Bytes shows higher packet 
%   loss for data and VoIP packets, but significantly lower average packet 
%   delays. Reducing f means that packets are smaller on average, 
%   leading to shorter queueing times and, therefore, lower average delays. 
%   The throughput remains relatively high due to the smaller packet size, 
%   allowing for more packets to be transmitted within the same time frame.


% Ex: 7.d - Repeat the experiment 7.c but now consider f = 2.000 Bytes 
%   (~2 KBytes) Justify the differences between these results and the 
%   results of experiment 7.b and 7.c.
fprintf('\nSimulation with f = 2.000 Bytes:\n');
F = 2000;
PLdata = zeros(1,iter); %vector with N simulation values
PLvoip = zeros(1,iter); %vector with N simulation values
APDdata = zeros(1,iter); %vector with N simulation values
APDvoip = zeros(1,iter); %vector with N simulation values
MPDdata = zeros(1,iter); %vector with N simulation values
MPDvoip = zeros(1,iter); %vector with N simulation values
TT = zeros(1,iter); %vector with N simulation values

for it= 1:iter
    [PLdata(it),PLvoip(it),APDdata(it),APDvoip(it),MPDdata(it),MPDvoip(it),TT(it)] = Simulator3(Lambda, C, F, P, n);
end
alfa= 0.1; % 90% confidence interval %
showStats(PLdata, PLvoip, APDdata, APDvoip, MPDdata, MPDvoip, TT, alfa, iter);

% Conclusion: Reducing the queue size to 2,000 Bytes indicates a higher 
%   packet loss for data packets and VoIP packets compared to experiment 
%   7.b and slightly higher average packet delays for both data and VoIP 
%   packets. Reducing f even further results in smaller packet sizes, which 
%   can lead to higher packet loss due to increased contention and queueing. 
%   However, the reduced packet size also results in lower average delays 
%   because smaller packets spend less time in the queue. The throughput 
%   remains relatively high, although it is slightly lower than in 
%   experiment 7.b due to the increased packet loss.
% Summary: this makes sense, because there will be packets until the
% transmitted bytes are superior than f, and with that, the data packets
% will - f parameter is the size of the queue


% Ex: 7.e - Run Simulator4 100 times with a stopping criterion of P = 10000 
%   at each run and to compute the estimated values and the 90% confidence 
%   intervals of all performance parameters when k = 1800pps, C = 10 Mbps, 
%   f = 1.000.000 Bytes (~1 MByte) and n = 20. Compare these results with 
%   the results of 7.b and take conclusions.
fprintf('\nSimulator4:\n');
iter = 100;
Lambda = 1800;
C = 10;
F = 1000000;
P = 10000;
n = 20;
PLdata = zeros(1,iter); %vector with N simulation values
PLvoip = zeros(1,iter); %vector with N simulation values
APDdata = zeros(1,iter); %vector with N simulation values
APDvoip = zeros(1,iter); %vector with N simulation values
MPDdata = zeros(1,iter); %vector with N simulation values
MPDvoip = zeros(1,iter); %vector with N simulation values
TT = zeros(1,iter); %vector with N simulation values

for it= 1:iter
    [PLdata(it),PLvoip(it),APDdata(it),APDvoip(it),MPDdata(it),MPDvoip(it),TT(it)] = Simulator4(Lambda, C, F, P, n);
end
alfa= 0.1; % 90% confidence interval %
showStats(PLdata, PLvoip, APDdata, APDvoip, MPDdata, MPDvoip, TT, alfa, iter);


function showStats(PLdata, PLvoip, APDdata, APDvoip, MPDdata, MPDvoip, TT, alfa, N)
    media = mean(PLdata);
    term = norminv(1-alfa/2)*sqrt(var(PLdata)/N);
    fprintf('PacketLoss of data(%%)\t\t = %.2e +- %.2e\n',media,term)
    media = mean(PLvoip);
    term = norminv(1-alfa/2)*sqrt(var(PLvoip)/N);
    fprintf('PacketLoss of VoIP(%%)\t\t = %.2e +- %.2e\n',media,term)
    media = mean(APDdata);
    term = norminv(1-alfa/2)*sqrt(var(APDdata)/N);
    fprintf('Av. Packet Delay of data (ms)\t = %.2e +- %.2e\n',media,term)
    media = mean(APDvoip);
    term = norminv(1-alfa/2)*sqrt(var(APDvoip)/N);
    fprintf('Av. Packet Delay of VoIP (ms)\t = %.2e +- %.2e\n',media,term)
    media = mean(MPDdata);
    term = norminv(1-alfa/2)*sqrt(var(MPDdata)/N);
    fprintf('Max. Packet Delay of data (ms)\t = %.2e +- %.2e\n',media,term)
    media = mean(MPDvoip);
    term = norminv(1-alfa/2)*sqrt(var(MPDvoip)/N);
    fprintf('Max. Packet Delay of VoIP (ms)\t = %.2e +- %.2e\n',media,term)
    media = mean(TT);
    term = norminv(1-alfa/2)*sqrt(var(TT)/N);
    fprintf('Throughput (Mbps)\t\t = %.2e +- %.2e\n',media,term)
end
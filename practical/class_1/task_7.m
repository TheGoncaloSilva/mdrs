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
showStats(PL, APD, MPD, TT, alfa, N);


function showStats(PLdata, PLvoip, APDdata, APDvoip, MPDdata, MPDvoip, TT, alfa, N)
    media = mean(PLdata);
    term = norminv(1-alfa/2)*sqrt(var(PL)/N);
    fprintf('PacketLoss of data(%%)\t\t = %.2e +- %.2e\n',media,term)
    media = mean(PLvoip);
    term = norminv(1-alfa/2)*sqrt(var(PL)/N);
    fprintf('PacketLoss of VoIP(%%)\t\t = %.2e +- %.2e\n',media,term)
    media = mean(APDdata);
    term = norminv(1-alfa/2)*sqrt(var(APD)/N);
    fprintf('Av. Packet Delay of data (ms)\t = %.2e +- %.2e\n',media,term)
    media = mean(APDvoip);
    term = norminv(1-alfa/2)*sqrt(var(APD)/N);
    fprintf('Av. Packet Delay of VoIP (ms)\t = %.2e +- %.2e\n',media,term)
    media = mean(MPDdata);
    term = norminv(1-alfa/2)*sqrt(var(MPD)/N);
    fprintf('Max. Packet Delay of data (ms)\t = %.2e +- %.2e\n',media,term)
    media = mean(MPDvoip);
    term = norminv(1-alfa/2)*sqrt(var(MPD)/N);
    fprintf('Max. Packet Delay of VoIP (ms)\t = %.2e +- %.2e\n',media,term)
    media = mean(TT);
    term = norminv(1-alfa/2)*sqrt(var(TT)/N);
    fprintf('Throughput (Mbps)      = %.2e +- %.2e\n',media,term)
end
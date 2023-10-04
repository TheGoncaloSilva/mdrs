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
alfa= 0.1; %90% confidence interval%
media = mean(PL);
term = norminv(1-alfa/2)*sqrt(var(PL)/N);
fprintf('PL = %.2e +- %.2e\n',media,term)
media = mean(APD);
term = norminv(1-alfa/2)*sqrt(var(APD)/N);
fprintf('APD = %.2e +- %.2e\n',media,term)
media = mean(MPD);
term = norminv(1-alfa/2)*sqrt(var(MPD)/N);
fprintf('MPD = %.2e +- %.2e\n',media,term)
media = mean(TT);
term = norminv(1-alfa/2)*sqrt(var(TT)/N);
fprintf('TT = %.2e +- %.2e\n',media,term)

% Ex: 5.b - Repeat the previous experiment but now run Simulator1 100 times. 
%   Compare these results with the previous ones and take conclusions.

N = 100; %number of simulations
for it= 1:N
    [PL(it),APD(it),MPD(it),TT(it)] = Simulator1(Lambda, C, F, P);
end
alfa= 0.1; %90% confidence interval%
media = mean(PL);
term = norminv(1-alfa/2)*sqrt(var(PL)/N);
fprintf('PL = %.2e +- %.2e\n',media,term)
media = mean(APD);
term = norminv(1-alfa/2)*sqrt(var(APD)/N);
fprintf('APD = %.2e +- %.2e\n',media,term)
media = mean(MPD);
term = norminv(1-alfa/2)*sqrt(var(MPD)/N);
fprintf('MPD = %.2e +- %.2e\n',media,term)
media = mean(TT);
term = norminv(1-alfa/2)*sqrt(var(TT)/N);
fprintf('TT = %.2e +- %.2e\n',media,term)


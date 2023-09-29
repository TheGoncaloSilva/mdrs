% Ex: 4.a - Average packet size (in Bytes) and the average packet transmission time of the IP flow
K = 1000; % pps
C = 10; % Mbps
max_capacity = 10*10^6;
delay = 10*10^-6;
min_package_size = 64;
max_package_size = 1518;
n_values = max_package_size-min_package_size+1;
size_prob = [[64 , 110, 1518]
             [.19, .23, .17 ]];
rem_prob = 1 - sum(size_prob(2,:));
probs = zeros(1,n_values);
probs(:) = rem_prob / (n_values-length(size_prob(2,:)));
for i = 1:length(size_prob(1,:))
    probs(size_prob(1,i)-min_package_size+1) = size_prob(2,i);
end

avg_bytes = 0;
for i = 1:length(probs)
    avg_bytes = avg_bytes + probs(i) * (i+64-1);
end

fprintf("The average packet size is: %.2f Bytes\n", avg_bytes);

avg_time = avg_bytes * 8 / K;
fprintf("The average package trasmission time is: %.2f seconds\n", avg_time);

% Ex: 4.b - Average throughput (in Mbps) of the IP flow
avg_throughput = K * avg_bytes * 8 / max_capacity;
fprintf('The average throughput (in Mbps) of the IP flow is: %.2f Mbps\n', avg_throughput);

% Ex: 4.c - Capacity of the link, in packets/second;
capacity_second = max_capacity / (avg_bytes * 8);
fprintf('The capacity of the link is: %.2f pps\n', capacity_second);

% Ex: 4.d - average packet queuing delay and average packet system delay of the IP flow 
%   (the system delay is the queuing delay + transmission time + propagation delay) using the 
%   M/G/1 queuing model;
x = 64:1518;
s = (x .* 8) ./ (max_capacity);
s2 = (x .* 8) ./ (max_capacity);
% similar to implemented in (A) however simpler in understanding
for i = 1:length(x)
    if i == 1
        s(i) = s(i) * 0.19;
        s2(i) = s2(i)^2 * 0.19;
    elseif i == 110-64+1
        s(i) = s(i) * 0.23;
        s2(i) = s2(i)^2 * 0.23;
    elseif i == 1518-64+1
        s(i) = s(i) * 0.17;
        s2(i) = s2(i)^2 * 0.17;
    else
        s(i) = s(i) * rem_prob / (n_values-length(size_prob(2,:)));
        s2(i) = s2(i)^2 * rem_prob / (n_values-length(size_prob(2,:)));
    end
end

Es = sum(s);
Es2 = sum(s2);
avg_time_sci = avg_time * 10^(-4);  % Convert to scientific notation
Wq = (K * Es2) / (2 * (1 - K * Es));
W = Wq + avg_time_sci + delay;

fprintf(['The average packet queuing delay is: %.2e seconds and the average packet system ' ...
    'delay of the IP flow is: %.2e seconds\n'], Wq, W);

% Ex: 4.e - plot the average system delay as a function of the packet
%   arrival rate k (from k = 100 pps up to k = 2000 pps)
y = 100:2000;
wq_func = (y * ES2) ./ (2 * (1 - y * ES));

figure(1);
plot(y, wq_func);
title("Average system delay (seconds)");
xlabel("{\lambda} (pps)")
grid on;





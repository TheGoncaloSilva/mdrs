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






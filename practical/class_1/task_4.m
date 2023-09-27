% Ex 4.a - Average packet size (in Bytes) and the average packet transmission time of the IP flow
K = 1000; % pps
C = 10; % Mbps
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

avg = 0;
for i = 1:length(probs)
    avg = avg + probs(i) * (i+64-1);
end

fprintf("The average packet size is: %.2f Bytes\n", avg);
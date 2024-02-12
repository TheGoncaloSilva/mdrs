% Ex: 3.a - probability of the link being in each of the five states
states = [10^-6, 10^-5, 10^-4, 10^-3, 10^-2];
probs = [[600, 100, 20, 5] 
         [8  , 5  , 2 , 1]];
state_probability = 1:5;
% Replaces this
% den = 1 + 8/600 + 8/600 * 5/100 + 8/600 * 5/100 * 2/20 + 8/600 * 5/100 * 2/20 * 1/5; 
% pstates(1) = 1 / den;
% pstates(2) = (8/600) / den;
% pstates(3) = (8/600 * 5/100) / den;
% pstates(4) = (8/600 * 5/100 * 2/20) / den;
% pstates(5) = (8/600 * 5/100 * 2/20 * 1/5) / den;
for i = 1:5
    state_probability(i) = (num(probs, i) / (1 + transition_sum(probs, 1)));
    fprintf("Probability of the link to be in the 10^%.0f state is: %2.2e\n", log10(states(i)), state_probability(i)*states(i));
end

% Ex: 3.b - average percentage of time the link is in each of the five states
fprintf("The average percentage of time the link is in each of the five states is equal to the probability of being in each of " + ...
    "the five states, just in percentage format. In summary, the probabiliy of a link to be in a state is equal to the average " + ...
    "percentage of time that the link stays in the respective state\n");

% Ex: 3.c - average ber of the link (1/values_out)
ber = sum(state_probability .* states);
fprintf("The average of the BER link is: %.2e\n", ber);

% Ex: 3.d - average time duration (in minutes) that the link stays in each of the five states
out = zeros(1,5);
out(1) = 1/8;
out(2) = 1/(600+5);
out(3) = 1/(100+2);
out(4) = 1/(20+1);
out(5) = 1/5;

for i=1:5
    fprintf('The average time duration that the link stays is state 10^%.0f is: %2.2f min\n', log10(states(i)), out(i)*60);
end

% Ex: 3.e - probability of the link being in the normal state and in interference state
normal_state = sum(state_probability(1:3)); % states smaller than 10^-3
interference_state = sum(state_probability(4:5)); % states >= than 10^-3
fprintf('The probabilty of the link being in the normal state is: %.6f\n', normal_state);
fprintf('The probabilty of the link being in the interference state is: %.2e\n', interference_state);

% Ex: 3.f - average ber of the link when it is in the normal state and when it is in the interference state
ber_normal = sum(state_probability(1:3) .* states(1:3))/normal_state;
ber_interference = sum(state_probability(4:5) .* states(4:5))/interference_state;
fprintf('The average ber of the link when is in the normal state is: %.2e\n', ber_normal);
fprintf('The average ber of the link when is in the interference state is: %.2e\n', ber_interference);

% Ex: 3.g - plot the probability of the packet being received by the destination station with at least one error 
%   as a function of the packet size (from 64 Bytes up to 1500 Bytes) -> 
%   P(E|Fi)
x = 64:1500;
byte_size = 8;
error_probability = 1 - (1 - states(:)).^(x .* byte_size);
y = sum(error_probability .* state_probability',1);

figure(1)
plot(x, y, 'LineWidth', 2)
hold on
title("Prob. of at least one error (%)")
xlabel("B (Bytes)")
grid on
hold off

% Ex: 3.h - considering that a data frame is received with at least one error by the destination station, 
%   plot the probability of the link being in the normal state as a function of the packet size 
%   (from 64 Bytes up to 1500 Bytes) -> P(Fi|E) Regra de Bayes
x = 64:1500;
byte_size = 8;
error_probability = 1 - (1 - states(:)).^(x .* byte_size);
den = sum(error_probability .* state_probability',1);

error_probability_normal = 1 - (1 - states(1:3))'.^(x .* byte_size);
numerator = sum(error_probability_normal .* state_probability(1:3)',1);

y = numerator ./ den;

figure(2)
plot(x, y, 'LineWidth', 2)
hold on
title("Prob. of Normal State (%)")
xlabel("B (Bytes)")
grid on
hold off


% Ex: 3.i - considering that a data frame is received without errors by the destination station, 
%   plot the probability of the link being in the interference state as a function of the packet size 
%   (from 64 Bytes up to 1500 Bytes) -> P(Fi|E) Regra de Bayes
x = 64:1500;
byte_size = 8;
error_probability = (1 - states(:)).^(x .* byte_size);
den = sum(error_probability .* state_probability',1);

error_probability_normal = (1 - states(4:5))'.^(x .* byte_size);
numerator = sum(error_probability_normal .* state_probability(4:5)',1);

y = numerator ./ den;

figure(3)
semilogy(x, y, 'LineWidth', 2)
hold on
title("Prob. of Interference State (%)")
xlabel("B (Bytes)")
grid on
hold off



% From Exercise 3.a
function result = transition_sum(probs, startIndex)
    % The startIndex should be 1, because 
    % Check if the arrays have compatible sizes
    if height(probs) ~= 2
        error('Bidimensional array expected');
    end
    if length(probs(1,:)) ~= length(probs(2,:))
        error('Sizes dont match.');
    end
    
    result = 0;
    for endIndex = 1:length(probs)
        % Perform element-wise division
        temp = probs(2,startIndex:endIndex) ./ probs(1,startIndex:endIndex);
        result = result + prod(temp);
    end

end

function result = num(probs, index)
    % Check if the arrays have compatible sizes
    if height(probs) ~= 2
        error('Bidimensional array expected');
    end
    if length(probs(1,:)) ~= length(probs(2,:))
        error('Sizes dont match.');
    end

    result = 1;
    if index == 1
        return;
    end
    for i=1:(index-1)
        result = result * (probs(2,i) / probs(1,i));
    end
end
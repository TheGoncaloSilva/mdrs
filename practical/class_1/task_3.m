% Ex: 3.a - probability of the link being in each of the five states
states = [10^-6, 10^-5, 10^-4, 10^-3, 10^-2];
probs = [[600, 100, 20, 5] 
         [8  , 5  , 2 , 1]];
state_probability = 1:5;
for i = 1:5
    state_probability(i) = 1 / (1 + transition_sum(probs, i));
    fprintf("Probability of the link to be in the 10^%.0f state is: %2.4f%%\n", log10(states(i)), state_probability(i)*100);
end
clear

% Ex: 3.b - average percentage of time the link is in each of the five states;
fprintf("The average percentage of time the link is in each of the five states is equal to the probability of being in each of " + ...
    "the five states, just in percentage format. In summary, the probabiliy of a link to be in a state is equal to the average " + ...
    "percentage of time that the link stays in the respective state");

% Ex: 3.c - the average ber of the link (1/values_out)
out = zeros(1,5);
out(1) = 1/8;
out(2) = 1/(600+5);
out(3) = 1/(100+2);
out(4) = 



% From Exercise 3.a
function result = transition_sum(probs, startIndex)
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
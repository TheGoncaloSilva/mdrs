% Ex: 3.a - probability of the link being in each of the five states
states = [10^-6, 10^-5, 10^-4, 10^-3, 10^-2];
probs = [[600, 100, 20, 5] 
         [8  , 5  , 2 , 1]];
state_probability = 1:5;
for i = 1:5
    state_probability(i) = 1 / (1 + transition_sum(probs, i));
    fprintf("Probability of the link to be in the 10^%.0f state is: %2.4f%%\n", log10(states(i)), state_probability(i)*100);
end


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
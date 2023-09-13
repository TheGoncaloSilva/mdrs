% Ex: 1.a - Calculate P(E)
P = 0.6;
N = 4;

res = P + (1-P)/N;
fprintf("The probability of the student to select the right answer is %2.1f%%\n", res*100);
clear

% Ex: 1.b - Calculate P(F1|E)
P = 0.7;
N = 5;

res = P * N/(1+(N-1)*P);
fprintf("The probability of the student to know the answer when he selects the right answer is %2.1f%%\n", res*100);
clear

% Ex: 1.c - Use P(E)
% x = linspace(0,1); % Create a vector of 10 evenly spaced points in [0,100]
% Fx1 = x + (1-x)/3;
% Fx2 = x + (1-x)/4;
% Fx3 = x + (1-x)/5;
% 
% figure(1)
% plot(x.*100, Fx1.*100, 'r-', x.*100, Fx2.*100, 'm-.', x.*100, Fx3.*100, 'b-', 'LineWidth', 2)
% title("Probability of right answer (%)")
% legend('n=3', 'n=4', 'n=5')
% xlabel("p (%)")
% ylim([0 100]);
% grid on
% clear
% --With for--
x = linspace(0, 1); % Create a vector of 10 evenly spaced points in [0,1]
n_values = [3, 4, 5]; % Values of n
colors = ['r-', 'm-.', 'b-']; % Plot colors

figure(1)
hold on
for i = 1:length(n_values)
    n = n_values(i);
    Fx = x + (1 - x) / n;
    plot(x * 100, Fx * 100, colors(i), 'LineWidth', 2)
end

title("Probability of right answer (%)")
legend('n=3', 'n=4', 'n=5')
xlabel("p (%)")
ylim([0 100]);
grid on
hold off
clear

% Ex: 1.d - Use P(F1|E)
x = linspace(0, 1); % Create a vector of 10 evenly spaced points in [0,1]
n_values = [3, 4, 5]; % Values of n
colors = ['r-', 'm-.', 'b-']; % Plot colors

figure(2)
hold on
for i = 1:length(n_values)
    n = n_values(i);
    Fx = x * n./(1+(n-1)*x); % Attention to the division by integer (not creating a matrix, but a scalar)
    plot(x * 100, Fx * 100, colors(i), 'LineWidth', 2)
end

title("Probability of knowing the answer (%)")
legend('n=3', 'n=4', 'n=5')
xlabel("p (%)")
grid on
hold off
clear

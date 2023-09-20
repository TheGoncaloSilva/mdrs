% Ex: 2.a - No errors
p = 10^-2; % BER
n = 100; % Bytes
byte_size = 8; % 1 byte = 8 bits
n_bits = n*byte_size;

res = nchoosek(n_bits, 0) * (1-p)^(n_bits);

fprintf("The probability of a data frame of 100 bytes to be received without errors is %2.4f%%\n", res*100);
clear

% Ex: 2.b - 1 error
p = 10^-3; % BER
n = 1000; % Bytes
byte_size = 8; % 1 byte = 8 bits
n_bits = n*byte_size;

res = nchoosek(n_bits, 1) * p * (1-p)^(n_bits);

fprintf("The probability of a data frame of 1000 bytes to be received with exactly one errors is %2.4f%%\n", res*100);
clear

% Ex: 2.c - 1 or more error
p = 10^-4; % BER
n = 200; % Bytes
byte_size = 8; % 1 byte = 8 bits
n_bits = n*byte_size;

res = 1 - (nchoosek(n_bits, 0) * (1-p)^(n_bits)); % O contrario de nao ter nenhum erro

fprintf("The probability of a data frame of 200 bytes to be received with one or more errors is %2.4f%%\n", res*100);
clear

% Ex: 2.d - packet received without errors
byte_size = 8; % 1 byte = 8 bits
x = logspace(-8, -2);
n_values = [100, 200, 1000]; % Values of n
colors = ['r-', 'm-.', 'b-']; % Plot colors

figure(1)
for i = 1:length(n_values)
    n = n_values(i);
    n_bits = n*byte_size;
    Fx = nchoosek(n_bits, 0) * (1-x).^(n_bits);
    semilogx(x, Fx * 100, colors(i), 'LineWidth', 2)
    hold on % Attention, it needs to be after the plot function
end

title("Probability of packet reception without errors (%)")
legend('100 Bytes', '200 Bytes', '1000 Bytes', 'Location', 'southwest')
xlabel("Bit Error Rate")
ylim([0 100]);
grid on
hold off
clear

% Ex: 2.e - packet received without errors
byte_size = 8; % 1 byte = 8 bits
x = 64:1518;%linspace(64*byte_size, 1518*byte_size);
n_values = [-4, -3, -2]; % Values of n
colors = ['r-', 'm-.', 'b-']; % Plot colors

figure(2)

for i = 1:length(n_values)
    n = n_values(i);
    Fx = (1-10^n).^(x*byte_size);
    semilogy(x, Fx, colors(i), 'LineWidth', 2)
    hold on
end

title("Probability of packet reception without errors (%)")
legend('ber=1e-4', 'ber=1e-3', 'ber=1e-2', 'Location', 'southwest')
xlabel("Packet Size (Bytes)");
grid on
hold off
clear
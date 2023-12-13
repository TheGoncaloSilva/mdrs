%% Exercise 12.a - 
close all
clc
clear

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

fprintf('Exercise 12.a:\n');

v= 2*10^5;    % km/sec
D= L/v;
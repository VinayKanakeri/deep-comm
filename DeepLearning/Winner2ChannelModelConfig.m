function [cfgWim,cfgLayout] = Winner2ChannelModelConfig(nSamples)
% The steps in creating the winner2 channel model is the following :
% 1. Creating the types of antennae array  

%SISO System
AA(1) = winner2.AntennaArray('Pos',[0,0,0]); % SISO System

%MIMO System
%AA(1) = winner2.AntennaArray('UCA',16,0.15); % BS multi antennae structure
%AA(2) = winner2.AntennaArray('UCA',4,0.05); % Multi(N) Antennae System

%2. Create the base and mobile station and assign the AA type to each

BSId = {1}; % Only one base station which is single element
MSId = [1]; % One one mobile station which also has single element

%2.1 Define the number of links between the BS and MS
numLinks = 1 ; % Number of links between BS and MS

%2.2 Define the range in which the entire BS and MS system are situated in
range = 300 ;% The range in which the entire system is located in 300mX300m

cfgLayout = winner2.layoutparset(MSId,BSId,numLinks,AA,range);

%3. Define the links between the BS and MS

cfgLayout.Pairing=[1 ;2]; % Pairing between the BS (first row) and MS (second row) numbers given by index
cfgLayout.ScenarioVector = 11 ; % Urban scenario refer MATLAB WINNER documentation for the number
cfgLayout.PropagConditionVector= 0; %NLOS = 0

%3.1 Define the positions of the BS and MS system

%BS
cfgLayout.Stations(1).Pos(1:2) = [50;100]; % 50m on the x axis and yaxis is 100m

%MS
cfgLayout.Stations(2).Pos(1:2) = [250;100]; % 200m from the BS
%cfgLayout.Stations(3).Pos(1:2) = [150;30]; % 200m from the BS

%Assign some velocity to the MS, assuming slow moving MS
cfgLayout.Stations(2).Velocity = rand(3,1) - 0.5 ;% m/s in all three directions
%cfgLayout.Stations(3).Velocity = rand(3,1) - 0.5 ;% m/s in all three directions
% Configure the channel parameters

x=rng;

cfgWim = winner2.wimparset;
cfgWim.NumTimeSamples = nSamples; % Length of channel array
cfgWim.FixedPdpUsed = 'yes'; 
cfgWim.CenterFrequency = 2.660e+09;
cfgWim.UniformTimeSampling = 'no';
cfgWim.DelaySamplingInterval = 5.0e-09;
cfgWim.RandomSeed = double(x.Seed);


end


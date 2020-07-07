%%% Script to estimate the background temp and temperature anomaly for each
%%% experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Location of thermocouples in meters from the (0,0) tank position (in
% front of chute)
X=[0 1 1 1.5 1.5 2 2 2.5 2.5 3 3 4 4 1 1 0 0 1 1 2 2 3 3 4 4 3.5 3.5 3 3 2 2 0];
Z=[0 5 30 5 30 5 30 5 30 5 30 5 30 5 30 0 0 5 30 5 30 5 30 5 5 5 30 5 30 5 30 0];
Y=[0 0 0 0 0 0 0 0 0 0 0 0 0 .5 .5 0 0 -.5 -.5 -.5 -.5 -.5 -.5 -.5 .5 0 0 .5 .5 .5 .5 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

'Load temperature data from the same experiment as the background data'
[filename, pathname] = uigetfile('*.csv', 'Pick the temperature log');
R=8;
C=2;
Temp=csvread(fullfile(pathname,filename),8,2);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot the "channel 0" and select when the current arrives to define start. 
figure
Channel=32;%channel of interest
plot(Temp(:,Channel));
%xlim([250 400]);
xlabel('time');ylabel('temp');title('thermocouple in the chute');
% Select when the current arrives at the thermocouple of interest
'select background temperature'
[xtrash,background] = ginput(1);
'select start and end times'
[start,ytrash] = ginput(2);
start=round(start); %start is an index in the thermocouple data
% start is the framenumber in the thermocouple data where the current arrives at point (0,0) and the experiment begins! 
close;

deltaT=mean(Temp(start(1):start(2),Channel))-background%temperature anomaly
detlaT2=max(Temp(start(1):start(2),Channel))-background%

%% 
% plot several different channels

figure;
plot(Temp(:,2));hold on;
plot(Temp(:,3));
plot(Temp(:,4));
plot(Temp(:,5))

xlabel('time (3hz)')
ylabel('Temperature (C)');
title('24 cm barrier');
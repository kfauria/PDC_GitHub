%Script to plot measurements from PDC experiments
% Created by Kristen Fauria January 2, 2018

% Must load in results from VelocityManual.m code first

%%% Load data %%%
[file folder]=uigetfile('*.mat');
load(fullfile(folder,file));
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;

subplot(3,1,1)
plot(Time,DIS,'.');hold on;
xlabel('time (s)');
ylabel('distance (m)');
hold on
subplot(3,1,2)
plot(DIS,Hsave,'.');hold on;
xlabel('distance (m)');
ylabel('height (m)');
hold on
subplot(3,1,3)
%first row of sed is sedimentation rate
% %second row is distance 
plot(Sed(2,:),Sed(1,:),'.');hold on;
xlabel('distance (m)');
ylabel('sedimentation (g cm^-^2 s^-^1)');
hold on
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a timeseries iddata object
% create distances in pixels to distances in meter
% create length with 200 entries
% the time variable fed into 2015_2201 is messed up and needs to be divided
% by 3^2
%Size=(1:1000);

PXx=2;
PXy=2;
%%% Create these if they don't already exist
DIS=Distance(:,1)./PXx./100;%convert distance to meters (Kristen changed this from 2 to 1.7
Hsave=(400-Height(:,2))./PXy./100;%convert height to meters (be careful which height column you are considering) ( changed from 4 to 2)

% find first real data point
figure;plot(Hsave(:,1))

ind=ginput(1);
%ind2=find(Time>ind(1),1);
ind2=round(ind(1));
ind2=1;
DIS=DIS(ind2:end)-DIS(ind2);%take distance starting from zero and at first index where distance is measured.
%DIS2(numel(Size)) = 0;%add zeros to the end of the matrix
Hsave=Hsave(ind2:end);
%H2(numel(Size)) = 0;%add zeros to the end of the matrix
STEP=10;
Ts=STEP/30;%timestep (s)
%dataE=iddata([DIS2 H2],[],Ts);% make the first column distance in meters and the second column height in meters

plot(DIS,Hsave)
%%
PXx=2;
PXy=2;
%%% Create these if they don't already exist
DIS=distance./PXx./100;%convert distance to meters (Kristen changed this from 2 to 1.7
Hsave=(400-height)./PXy./100;%convert height to meters (be careful which height column you are considering) ( changed from 4 to 2)

% find first real data point
figure;plot(DIS(:,1))

ind=ginput(1);
%ind2=find(Time>ind(1),1);
ind2=round(ind(1));
ind2=1;
DIS=DIS(ind2:end)-DIS(ind2);%take distance starting from zero and at first index where distance is measured.
%DIS2(numel(Size)) = 0;%add zeros to the end of the matrix
Hsave=Hsave(ind2:end);
%H2(numel(Size)) = 0;%add zeros to the end of the matrix
STEP=10;
Ts=STEP/30;%timestep (s)
%dataE=iddata([DIS2 H2],[],Ts);% make the first column distance in meters and the second column height in meters

plot(DIS,Hsave)
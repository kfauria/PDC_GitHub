% Script to go through plots of a current and manually select the leading
% edge
% Created by Kristen on April 20, 2017
% Modified by Kristen July 2020
%clear all
%close all
Folder=uigetdir;
Files = dir(fullfile(Folder,'/*.mat')); %Get all the names of the files in the directory of interest
NumFiles = size(Files,1); %Total number of files
%%
%%% Here we create the Backround file that is subtracted from the others
close all
load([Folder '/' Files(1).name]);
%bkg=MAPcorrect;
bkg=MAP2;
%%% Here we cycle through the files until we find the frame where the
%%% current enter the screen. We call this frame "start"

STEP=15;
%STEP=1;
figure
for i=STEP:STEP:NumFiles
     load([Folder '/' Files(i).name]);
     hold on;
     
     caxis([50 500]);
     set(gca,'colorscale','log')
     %%%subplot(3,6,(i-1));
     image(MAP2-bkg);colormap('hot');axis image;set(gca, 'YDir', 'reverse');axis image;
     %image(MAPcorrect-bkg);colormap('hot');axis image;set(gca, 'YDir', 'reverse');axis image;
     set(gca,'colorscale','log')
     %caxis([0 10]);
     Distance(i/STEP,:)=ginput(1);
     Height(i/STEP,:)=ginput(1);
     %Time(i/STEP)=i/(30);%time of each frame in seconds
     hold off;
     
%      if i>=2*STEP 
%          Velocity(i/STEP)=Distance(i/STEP)-Distance(i/STEP-1)/(1/30*STEP);%velocity in pixels/s
%      end
    
end
    
%%
% Now calculate distances in real units
figure;
PX=2;% pixels/cm conversion
% calibration suggests that there may be ~1.76 pixels per horizontal cm and
% closer to 2 pixels per vertical cm

DIS=(Distance(:,1)-Distance(1,1))/PX/100;%convert runout distances to meters
H=(400-Height(:,2))/PX/100;
TIME=(1:length(DIS))./(30/STEP);
for i=2:length(Distance)
    VEL(i)=(DIS(i)-DIS(i-1))/(STEP/30);%velocity in meters per second
end
%VEL2=smooth(VEL)*100;%smooth this velocity vector, cm/s
%TIME=Time;
figure;
subplot(2,3,1)
plot(TIME,DIS,'.')
xlabel('time (s)');
ylabel('distance (m)');
set(gca,'FontSize',20);hold on;
subplot(2,3,2);
%plot(DIS,VEL2);
xlabel('distance (m)');
ylabel('velocity (cm/s)');
set(gca,'FontSize',20);hold on;
subplot(2,3,3)
plot(DIS,H,'.');
xlabel('distance (m)');
ylabel('height (m)');
set(gca,'FontSize',20);hold on;
subplot(2,3,4)
%plot(Sed(2,:),Sed(1,:)/40,'o');
plot(TIME,H,'.');
xlabel('time (s)');
ylabel('height (m)');
hold on
%xlabel('distance (m)');
%ylabel('sedimentation g cm^-^2 s^-^1');
%xlim([0,5]);

%%
% Plot with real units for T2iUp width measurements


figure;
PX=2;%cm per pixel conversion

DIS=(Distance(:,2)-Distance(1,2))/PX/100;%convert runout distances to meters
Width=3-(Distance(:,1)-Distance(1,1))/PX/100;
subplot(3,1,1)
plot(Time,DIS,'ko')
xlabel('time (s)');
ylabel('runout distance (m)');
set(gca,'FontSize',20);
subplot(3,1,2)
plot(Time,Width,'bo')
xlabel('time (s)');
ylabel('width (m)');
set(gca,'FontSize',20);
% Create a composite between the two at a select time
temp=ginput(1);

ind=find(Time<=temp(1,1));
ind=ind(end);%index point to create the runout distance composite

Comp1=DIS(1:ind);
Comp2=Width(ind+1:end);
diff=DIS(ind)-Width(ind);
Comp2=Comp2+diff;

Comp=vertcat(Comp1, Comp2);

% Look at the composite
subplot(3,1,3)
for i=1:length(Time)
    if i<=ind
        plot(Time(i),Comp(i),'ko');hold on
    else
        plot(Time(i),Comp(i),'bo'); hold on
    end
end
xlabel('time (s)');
ylabel('composite distance (m)');
set(gca,'FontSize',20);

%%
% Plot DIS2 on top of 20140722_01 data
close all
figure
hold on
subplot(2,1,1)
plot((1:length(DIS2))./3,DIS2,'ko');hold on
plot([12,12],[5,0],'k');
xlabel('time (s)');
ylabel('runout distance (m)');
set(gca,'FontSize',20);

subplot(2,1,2)
plot(Time,Width,'bo')
hold on
plot([12,12],[5,0],'k');
xlim([0 100]);
xlabel('time (s)');
ylabel('width (m)');
set(gca,'FontSize',20);

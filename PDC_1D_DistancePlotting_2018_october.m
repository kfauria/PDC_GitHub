% Plot different current variables with distance for specific initial
% conditions
% Created by Kristen Fauria
% May 2016
% Modified to Compare to experimental data in 2018

%type 1 = currents that entrain air but don't sediment
%type 2 = currents that sediment and entrain air
%type 3 = cold? particle splash
%type 4 = hot? particle splash
%type 5 = particle sedimentation but no air entrainment (this won't work
%because it will runout forever and won't become buoyant)

%%% Preliminaries %%%

CA=1.005;%heat capacity, (kJ/(kg K))
CR=0.84;%heat capacity of basalt, (kJ/(kg K));
B=3.43*10^-3;%expansion coefficient, air (1/K)
R=8.314;%specific gas constant (J/(mol K));
P=10^5;%atmospheric pressure (Pa)
M=1/(28.97/1000); %molar mass of air (kg/mol)
%E = 0.28; %Entrainment rate (0.25) works well for the unconfined current
G = 9.8; % gravity m/s2
DT=1/3; %time step in seconds (make the same as in dataE

%%% Initial conditions for all currents %%%

% Temperatures
TA=21.5+273; % amibent temperature = 20 degrees C.+273
RHOA = P/(M*R*TA); % density of the ambient air kg/m3

%%%%%% Modify to match for each experiment %%%%%%%%%
Width=.6;%width in meters (m)
ms=3.27;%mass delivery rate per second (g/s)
Vi=0.3;%initial speed (m/s)
Hi=0.2;%initial height of the current (m) %this should be changed for each experiment
%%% Initial temperature of the rocks in the mixture %%%
TMi = TA+11.2; %initial temperature of the particle, air mixture 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Mass of particles in different size fractions %
mass=ms/Vi/Width/1000; %(mass/average velocity/width) (kg/m^2)


MP1 = [mass 0]; %Change this to change the initial mass of particles throughout the models (kg) temp =0.0037
D = [20*10^-6 0.01]; % diameter of each particle size fraction (m) (fine volcanic ash < 0.063 mm)
RHOP = [2800 1000]; % density of each particle size fraction (kg/m^3) (talc powder density)
PVEL = [0 0]; %prescribed particle sedimentatin velocity m/s
prescribe = 0; % prescribe = 0 allows settling velocities to be calculated via Dufek et al. 2009 code, prescribe = 1 (or anything else transfers the values on the previous line)

%%
%%% Compare model results to the measured runout distance, liftoff time, and height at liftoff
%%%(created by Kristen August 2018)

type=2; % type of model to run

% cycle through Fr # from 1- sqrt(2) and E from 0.15  to 3; find combos
% that match the data
k=1; %counter

for Fr=0.8:0.02:1.4%1:0.05:1.4
    for E=0.2:0.02:0.8
k%display counter
RHOCi = P/(M*R*TMi); % calculate initial density
MA1=Hi*RHOCi; % calculate initial air mass in the current
[RO,RHOM,H,U,MASS,TM,X,VRVT,PVEL,i,PSAVE,SED,SED2,TT]=PDC_1D_adjusted(type,TMi,MP1,RHOP,MA1,CA,CR,R,P,M,E,G,Fr,DT,TA,RHOA,D,PVEL,prescribe);
hold on
Results2(k,1)=X(end);
Results2(k,2)=H(end);
Results2(k,3)=i/3;
Results2(k,4)=(H(end)-0.2)/X(end);%slope of the figure
Results2(k,5)=Fr;
Results2(k,6)=E;
Results2(k,7)=TMi-TA;
Results2(k,8)=TT(end);%make sure keeping track of time ok
clear TT
k=k+1;% counter
        end 
    end


%%
% Now compare the model results to the experimental results to determine
% the best fit
%%% Enter the experimentally determined values for total time, runout
%%% distance, and end current height;

Time=20;%35;%24.3; %time in seconds to liftoff, 40
Dist=3.2; % runout distance in meters
Htest=1.6; % current height at liftoff in meters
SLOPE=0.49;%slope of the rise to run plot,031
for i=1:length(Results2)
    %fit2(i)=sqrt(((Results2(i,4)-SLOPE)^2+(Results2(i,8)-Time)^2)/2);%fit just based on slope
    %fit(i)=(((Results2(i,4))-(SLOPE))^2+(Results2(i,8)-Time)^2)/2;
    %fit3(i)=fit(i)+fit2(i);
    fit(i)=sqrt(((Results2(i,8)-Time)^2+(Results2(i,1)-Dist)^2+(Results2(i,2)-Htest)^2)/3);
    %fit(i)=sqrt(((Results2(i,8)-Time)^2+(Results2(i,1)-Dist)^2)/2);
end

Pick=find(fit==min(fit)) % pick out the compilation of values with the best fit
Results2(Pick,:)

x2=Results2(:,5); % label new results
y2=Results2(:,6);
z2=Results2(:,7);

%% Now visually compare the fitted model result to the data
%Fr=Results(Pick,1);
%E=Results(Pick,2);
clear TM
Fr=1.2
E=0.49

RHOCi = P/(M*R*TMi); % calculate initial density
MA1=Hi*RHOCi; % calculate initial air mass in the current
[RO,RHOM,H,U,MASS,TM,X,VRVT,PVEL,i,PSAVE,SED,SED2,TT]=PDC_1D_adjusted(type,TMi,MP1,RHOP,MA1,CA,CR,R,P,M,E,G,Fr,DT,TA,RHOA,D,PVEL,prescribe);

%plot(X',H','.');
hold on
plot(TT,X,'k.');hold on; % plot the runout results
plot(TT,H,'ko'); %plot the height results
%%
% Now compare the model to the experimental results
tt=(1:length(DIS))./3;
%%%%hold on;plot(tt,DIS-DIS(1),'.')
hold on;plot(tt,DIS,'.')
hold on;plot(tt,Hsave,'.');
%hold on;plot(tt,DIS2,'kx')
%hold on;plot(tt,Hsave2,'kx')
set(gca,'FontSize',20)

xlabel('time (s)')
ylabel('distance (m)');
%% plot 2D results

set(gca,'colorscale','log')

figure
x=Results2(:,5);
y=Results2(:,6);
z=fit';
scatter(x,y,600,z,'filled','s')
xlabel('Froude Number');
ylabel('Entrainment coefficient');
set(gca,'FontSize',20);
set(gca,'colorscale','log')
caxis([1 10^3])
%dataM2=idresamp(dataM,10/3);%resample the data to match the time step of the measured data

%%% This may allow direct comparison between data and model

% subplot(3,1,1); set(gca,'FontSize',20); hold on
% T=1:length(X);T=T.*DT;%time variable
% semilogx((1:length(X))*DT,X,F(type),'LineWidth',2);
% xlabel('time (s)');
% ylabel('distance (m)');
% hold on
% 
% subplot(3,1,2); set(gca,'FontSize',20); hold on
% semilogx(X,H,F(type),'LineWidth',2);
% ylabel('height (m)');
% xlabel('distance (m)');
% 
% subplot(3,1,3); set(gca,'FontSize',20); hold on
% semilogx(X,SED2/10,F(type),'LineWidth',2);
% xlabel('distance (m)');
% ylabel('sedimentation (gcm^-^2 s^-^1)');

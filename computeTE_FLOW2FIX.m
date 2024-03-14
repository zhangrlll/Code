
function [FixationState,InfChange] = computeTE_FLOW2FIX(FileName)
%% Study between eye movement and task performance (VR driving average acceleration)
% Proposal: Information varies  by two velocities have strong correlation to performance
% also including computation and comparision of GTE, fixation rate, entropy
% rate...
% DataM stores the data: 10 indicators in lines,14 participants in raws, 4
% scenes in the 3rd dimension. The last indicator means the
% task performance(efficiency), 1/acceleration.
% by zrl 2022-8 runlin@tju.edu.cn

ScenesName={'Day';'DuskOn';'DuskOff';'Night'};
DataM=zeros(14,9,4);

[raw]=readtable(FileName);
FixationLength=size(raw,1);  %%有多少条数据

%% Breakpoints at "stop" to show the DATA till then
sstop=1;    % output the results based on first sstop*100% fixation data (first * percent data; for example, sstop=0.9 means the first 90% data) 
stop=floor((FixationLength)*sstop); % stop=the number of fixations used for computation     向负无穷大方向取整  整体作用，stop代表需要使用的数据量 

file = readtable(FileName,'ReadRowNames',false);

Duration = table2array(file(1:stop,3:3));

FixationHitName = table2array(file(1:stop,8:8));

Velocity = table2array(file(1:stop,9:9));

r = table2array(file(1:stop,12:12));

Theta = table2array(file(1:stop,10:10));

Phi = table2array(file(1:stop,11:11));

FixationStartT = table2array(file(1:stop,7:7));
%% Data preprocessing
% Fixations hit on the driver's car lead to wrong velocity computation


%%%%%% Remove fixations hit on the car ( "Kooper")  
F=cell(1,1);P=zeros(1,1);Spe=zeros(1,1);dur=zeros(1,1);Th=zeros(1,1);R=zeros(1,1);Ft=zeros(1,1);
j=1;cnt=0;
    for i=1:1:stop
        if ( strcmp(FixationHitName(i),'Kooper'))
            cnt=cnt+1;
            continue;
        end
        F(j,1)=FixationHitName(i);P(j)=Phi(i);Th(j)=Theta(i);dur(j)=Duration(i);R(j)=r(i);Spe(j)=Velocity(i);Ft(j)=FixationStartT(i);
        j=j+1;
    end
FixationHitName=F;Phi=P;Theta=Th;Duration=dur;Velocity=Spe;r=R;FixationStartT=Ft;
stop=stop-cnt;     



%% Visual motion for each fixation
VisualAngleHalf=1;
PI=3.142;
VelocityProj=zeros(1,stop);  % Projection velocity of the direction parrallel with the sight line
VelocityTangential=zeros(1,stop);  % Projection velocity of the direction vertical to the sight line
for i=1:stop

    VelocityTangential(1,i)=(1-sind(Phi(i))^2*sind(Theta(i))^2)^0.5/r(i);
end
InfChange=(VelocityTangential+VelocityProj).*Duration.*Velocity;    %InfChange=visual motion for all fixations 
FixationState = cat(2, Phi.', Theta.', r.');   
%     end
% end



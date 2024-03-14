% function [InfChange] = computeTE_FLOW2FIX(FileName,FixationVec_state)
function [FixationState,FixationHitName,AoiName] = proprocess(FileName)
%% Study between eye movement and task performance (VR driving average acceleration)


ScenesName={'Day';'DuskOn';'DuskOff';'Night'};
DataM=zeros(14,9,4);
[raw]=readtable(FileName);
FixationLength=size(raw,1);  %%有多少条数据

sstop=1;    % output the results based on first sstop*100% fixation data (first * percent data; for example, sstop=0.9 means the first 90% data) 
stop=floor((FixationLength)*sstop); % stop=the number of fixations used for computation   

file = readtable(FileName,'ReadRowNames',false);
Duration = table2array(file(1:stop,3:3));
FixationHitName = table2array(file(1:stop,8:8));
AoiName = table2array(file(1:stop,8:8));
Velocity = table2array(file(1:stop,9:9));
r = table2array(file(1:stop,12:12));
Theta = table2array(file(1:stop,10:10));
Phi = table2array(file(1:stop,11:11));

FixationStartT = table2array(file(1:stop,7:7));
%% Data preprocessing
% Fixations hit on the driver's car lead to wrong velocity computation


%%%%%% Remove fixations hit on the car ( "Kooper")  
%{
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
%}


%% Visual motion for each fixation

FixationState =[ Phi,Theta,r,Duration,Velocity];  
%     end
% end



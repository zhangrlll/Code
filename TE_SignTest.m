function [TEE2HBiasRemoved,TEH2EBiasRemoved,ISEye,ISHead,performance1,performance2,sE2H,sH2E] = TE_SignTest(~,FileName_f)
%% Transfer Entropy


file = readtable(FileName_f,"ReadRowNames",false);
speed = table2array(file(:,9:9));
duration = table2array(file(:,3:3));
FixationStartT = table2array(file(:,7:7));

acc = zeros(size(duration,1),1) ;
for dur_index = 1:size(duration,1)-1
      acc(dur_index,1) = abs(speed(dur_index)-speed(dur_index+1))/(FixationStartT(dur_index+1)-FixationStartT(dur_index)-duration(dur_index)/2+duration(dur_index+1)/2);
end

performance1 = 1;

acc_avg = mean(acc);
performance2 = 1/acc_avg;
%% TE Computation
bin=5;
PupilWindowHalfWidth=5;
SurrogateTimes=1000;%2/a-1;
SourceLen=1;TargetLen=1;
ScenesName={'Day';'DuskOn';'DuskOff';'Night'};
sNo=1;pNo=1;
   


        [FixationVec_state,OpticalFlow_state ]= computeTE_FLOW2FIX(FileName_f);  %传参时转置
        [TEEye2Head,EREye2Head]=TransferEntropy(bin,FixationVec_state,SourceLen,OpticalFlow_state.',TargetLen);
        [TEHead2Eye,ERHead2Eye]=TransferEntropy(bin,OpticalFlow_state.',SourceLen,FixationVec_state,TargetLen);

        ISEye= TEEye2Head;
        ISHead= TEHead2Eye;

        %% Surrogate
        SE2H=zeros(1,SurrogateTimes);
        SH2SE=zeros(1,SurrogateTimes);
        SH2E=zeros(1,SurrogateTimes);
        SE2SH=zeros(1,SurrogateTimes);
        for st=1:SurrogateTimes

            SE=Surrogate(FixationVec_state);
            SH=Surrogate(OpticalFlow_state.');
            [SE2SH(1,st),ERSE2SH]=TransferEntropy(bin,SE,SourceLen,SH,TargetLen);
            [SH2SE(1,st),ERSH2SE]=TransferEntropy(bin,SH,SourceLen,SE,TargetLen);
            [SE2H(1,st),ERSE2H]=TransferEntropy(bin,SE,SourceLen,OpticalFlow_state.',TargetLen);
            [SH2E(1,st),ERSH2E]=TransferEntropy(bin,SH,SourceLen,SE,TargetLen);

        end
        %% Normalised TE

        sH2E = mean(SH2E);
        TEE2HBiasRemoved=(TEEye2Head-mean(SE2H))/EREye2Head;
        TEH2EBiasRemoved=(TEHead2Eye-mean(SH2E))/ERHead2Eye;

        %% Significance test  sE2H=TElevel
        sE2H=abs(TEHead2Eye-mean(SH2E))/std(SH2E);
        sH2E=(TEHead2Eye-TEEye2Head-mean(SH2SE-SE2SH))/std(SH2SE-SE2SH);

        num_ttest = 0;
        

        [h,p,ci,stats] = ttest(SE2H,ISEye,'Tail','right')
        sH2E = p; 
        sE2E = 0;


        %% data
        Data(sNo,:,pNo)=[TEEye2Head,EREye2Head,TEE2HBiasRemoved,sE2H,TEHead2Eye,ERHead2Eye,TEH2EBiasRemoved,sH2E];


end


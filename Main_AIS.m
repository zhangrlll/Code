ScenesName_previous={'Day';'DuskOn';'DuskOff';'Night'};

mean_AIS = zeros(56,6);
for sNo=1:1:4
    CurrentSceneName=ScenesName_previous{sNo};
    name_num  = sNo-1;
    for i=1:1:14
        name_line = name_num * 14 + i;
        fprintf('nameNo:%d---',name_line);

        FileName_fixation = ['.\data_Fixation\',num2str(i),CurrentSceneName,'.xlsx'];

        binNum=5;

        Duration_fixation = readtable(FileName_fixation,'ReadRowNames',false);
        Duration_fixation = table2array(Duration_fixation(:,3:3));
        [FixationVec_state,OpticalFlow_state] = computeTE_FLOW2FIX(FileName_fixation);  %传参时转置


        [IT_gaze2head,Max_I_E] = AIS_global(binNum,FixationVec_state);
        [IT_head2eye,Max_I_H]  = AIS_global(binNum,OpticalFlow_state.'); % .' 代表转置
        mean_AIS(name_line,1) = IT_gaze2head;   %AIS fixation
        mean_AIS(name_line,2) = IT_head2eye;    %AIS optical flow
        mean_AIS(name_line,3) = IT_head2eye - IT_gaze2head;
        mean_AIS(name_line,4) = IT_gaze2head - IT_head2eye;

         %% Surrogate
        SurrogateTimes =1000;
        SE_AIS=zeros(1,SurrogateTimes);
        SH_AIS=zeros(1,SurrogateTimes);

        for st=1:SurrogateTimes
            SE=Surrogate(FixationVec_state);
            SH=Surrogate(OpticalFlow_state.');
            SE_AIS(1,st)=AIS_global(binNum,SE);
            SH_AIS(1,st)=AIS_global(binNum,SH);
        end
        %% Normalised TE
        sE2H = mean(SE_AIS); 
        stdAISf = std2(SE_AIS);
        sH2E = mean(SH_AIS);
        stdAISo = std2(SH_AIS);
        slevelAf = (IT_gaze2head-sE2H)/stdAISf;
        slevelAo = (IT_head2eye-sH2E)/stdAISo;

        AIS_E_BiasRemoved=(IT_gaze2head-sE2H)/Max_I_E;   
        AIS_H_BiasRemoved=(IT_head2eye-sH2E)/Max_I_H;
        [Hf,SIGf] = ztest(IT_gaze2head,sE2H,stdAISf,0.001,0); 
        [Ho,SIGo] = ztest(IT_head2eye,sH2E,stdAISo,0.001,0); 
        mean_AIS(name_line,5) = Hf;
        mean_AIS(name_line,6) = slevelAf;
    end
end
 xlswrite('AIS_old_3.xls',mean_AIS);

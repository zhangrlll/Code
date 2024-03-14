res=zeros(30,12);
significanceTest=zeros(30,4);
ScenesName_previous={'Day';'DuskOn';'DuskOff';'Night'};
ScenesName={'d';'n'};
for sNo=1:1:4
    CurrentSceneName=ScenesName_previous{sNo};
    name_num  = sNo-1;
    for i=1:1:14
        name_line = name_num * 14 + i;
        fprintf('nameNo:%d',name_line);
        FileName_fixation = ['.\data_Fixation\',num2str(i),CurrentSceneName,'.xlsx'];
        fprintf('file_name:%s',FileName_fixation);
        fileName_gaze = ".\data_gaze\12Day.xlsx";
        [Eye2Head,Head2Eye,ISEye,ISHead,performance1,performance2,sE2H,sH2E]=TE_SignTest(fileName_gaze,FileName_fixation);
        res(name_line,1)=Eye2Head; %fixation to optical flow
        res(name_line,2)=Head2Eye; %optical flow to fixation
        res(name_line,3)=ISEye;
        res(name_line,4)=ISHead;
        res(name_line,5)=performance1;
        res(name_line,6)=performance2;
        res(name_line,11)=sE2H;
        res(name_line,12)=sH2E;
        
        significanceTest(name_line,1) = sE2H;
        significanceTest(name_line,2)=sH2E;

    end
end
 xlswrite('res_mean_3D_Nonomal_doSig_old14_3',res);
%  xlswrite('significanceTest',significanceTest);
 title=["�����۵�ͷTE","����ͷ����TE","�����۴洢","����ͷ�洢","������֣�ֱ���ɳ��ٻ�ã�","������֣��ɳ�������ã�", "ҹ���۵�ͷTE","ҹ��ͷ����TE","ҹ���۴洢","ҹ��ͷ�洢","ҹ����֣�ֱ���ɳ��ٻ�ã�","ҹ����֣��ɳ�������ã�"];
 xlswrite('title',title);
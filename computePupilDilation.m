%Add two new data in 20210524 pz
res=zeros(30,12);
significanceTest=zeros(30,4);
ScenesName_previous={'GDay';'GDuskOn';'GDuskOff';'GNight'};
for sNo=1:1:4
    CurrentSceneName=ScenesName_previous{sNo};
    name_num = sNo-1;
    for i=1:1:14

        name_line = name_num * 14 + i;
        fprintf('nameNo:%d',name_line);

        FileName_fixation = ['.\GazeData\',num2str(i),CurrentSceneName,'.csv'];
        fprintf('file_name:%s',FileName_fixation);
        [pupil_dilation]=pupilDilation(FileName_fixation);
        res(name_line,1)=pupil_dilation; %fixation to optical flow

    end
end
 xlswrite('pupildilation',res);
%  xlswrite('significanceTest',significanceTest);
 title=["瞳孔间距"];
 xlswrite('title',title);
function [pupilDilation] = pupilDilation(filename)
%PUPILDILATION 此处显示有关此函数的摘要
%   此处显示详细说明
file = readtable(filename,"ReadRowNames",false);
pupil =  table2array(file(:,4:4));

pupilDilation = std(pupil);



end


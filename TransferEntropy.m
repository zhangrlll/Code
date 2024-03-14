%% Transfer Entropy
%：Y→X = Source->Target
function [TE,EntropyRate] = TransferEntropy(bin,Source,SHistory,Target,THistory)
%bin = 5; Source = EyeState, Target = HeadState(表示两个角度),
% ，SHistory = THistory=1
TargetLen=size(Target,1);  %返回行数size(A,1)即数据行数6823
SourceLen=size(Source,1);  %source 的个数
xwidth=size(Target,2);     %返回列数size(A,2),此处返回2（表示有两个角度）

jointLen=TargetLen-max(SHistory,THistory);
xt=Target(TargetLen-jointLen+1:TargetLen,:);
xh=zeros(jointLen,THistory*xwidth);%6823*2 double
for i=1:THistory
    xh(:,(i-1)*xwidth+1:i*xwidth)=Target(TargetLen-jointLen-i+1:TargetLen-i,1:xwidth);
end
ywidth=size(Source,2);
yh=zeros(jointLen,SHistory*ywidth);

for i=1:SHistory
    yh(:,(i-1)*ywidth+1:i*ywidth)=Source(SourceLen-jointLen-i+1:SourceLen-i,1:ywidth);

end
HistJoint=JointP(bin,[xt,xh,yh]);
HistTargetHistory=JointP(bin,xh);
HistTargetHistoryJointSourceHistory=JointP(bin,[xh,yh]);
HistTargetJointTargetHistory = JointP(bin,[xt,xh]);
EntropyRate = Entropy(HistTargetJointTargetHistory)-Entropy(HistTargetHistory);
TE = Entropy(HistTargetHistoryJointSourceHistory)- Entropy(HistTargetHistory) + Entropy(HistTargetJointTargetHistory)  - Entropy(HistJoint);

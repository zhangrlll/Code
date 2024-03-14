function [JS_divergence] = JSD(P1,P2)
%JSD 此处显示有关此函数的摘要
%   此处显示详细说明
% 计算平均分布 Q
P1(P1==0)=eps;
P2(P2==0)=eps;
Q = (P1 + P2) / 2;

% 计算 KL散度
D1 = sum(P1 .* log2(P1 ./ Q));
D2 = sum(P2 .* log2(P2 ./ Q));

% 计算 JS散度
JS_divergence = (D1 + D2) / 2;
%JS_divergence = sqrt(JS_divergence);
end


function [GTE_res] = GTE(AOI_sqe)
%GTE 此处显示有关此函数的摘要
%   此处显示详细说明

AOI_max = max(AOI_sqe(:,1));

%Pij 
Combine_data = zeros(AOI_max,AOI_max);

for i=1:length(AOI_sqe)-1
   Combine_data(AOI_sqe(i,1),AOI_sqe(i+1,1))  = Combine_data(AOI_sqe(i,1),AOI_sqe(i+1,1))+1;
end
%Pij概率

Combine_prob = Combine_data/sum(sum(Combine_data));
row_entropy = zeros(AOI_max,1);
row_prob = zeros(AOI_max,1);
for i=1:AOI_max
    row_entropy(i) = Entropy(Combine_prob(i,:));
    row_prob(i) = sum(Combine_prob(i,:));
end
GTE_res = 0;
for i=1:AOI_max
    GTE_res = GTE_res+row_prob(i)*row_entropy(i);
end



end


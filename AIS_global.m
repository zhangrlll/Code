function [I,Max_I] = AIS_global(binNum,dataI) %I的信息存储
i_len_line = size(dataI,1);  %行数
i_len_col = size(dataI,2);   %列数

i_min = min(dataI);
i_max = max(dataI);

idx_y_z = (i_max-i_min)/binNum;   % (1,3) - (1,3)  （用bin分格子 分成bin*bin格子） 
Dimensions_i2j = zeros(1,2);    %  xh xt 
Dimensions_i2j(1,:) = binNum .^ i_len_col; 
binTransij2j = zeros(Dimensions_i2j); 
Dimensions_xh = zeros(1,1);    %  xh  
Dimensions_xh(1,:) = binNum .^ i_len_col; 
binTransi_xh = zeros(1,Dimensions_xh);  %此处可能存在问题，对比binTransij2j没有（1，）
Dimensions_xt = zeros(1,1);    %  xh  
Dimensions_xt(1,:) = binNum .^ i_len_col; 
binTransi_xt = zeros(1,Dimensions_xt); 
iAddressBook = ceil((dataI - i_min) ./ idx_y_z); %记录每个gaze被分到的bin的坐标
iAddressBook( iAddressBook ==0 ) = 1;
Book_num = size(iAddressBook , 2); %表示维度， ！此处也可能存在问题（对于TE而言），如果是三维，那么不适用。

for k=1:i_len_line    
    if(k>=2)
        xt = iAddressBook(k,1);
        xh = iAddressBook(k - 1,1);
        for m = 2 : Book_num   %将bin转为一维
            xt = xt + (iAddressBook(k,m) - 1) * (binNum .^ (m - 1));
            xh = xh + (iAddressBook(k - 1,m) - 1) * (binNum .^ (m - 1));   %对在不同维度的bin重新编号，例如三维5*5*5 就变成1-125
        end
        binTransi_xh(xh) = binTransi_xh(xh) + 1;
        binTransi_xt(xt) = binTransi_xt(xt) + 1;
        binTransij2j(xh , xt) = binTransij2j(xh , xt) + 1;    %记录转移的次数 xt->xh
    end
    
end
MetricPh = binTransi_xh ./ sum(binTransi_xh(:));   
MetricPt = binTransi_xt ./ sum(binTransi_xt(:));
MetricPht = binTransij2j ./ sum(binTransij2j(:));  %计算概率 p(xt) p(xt-1) p(xt,xt-1)

Hx = Entropy(MetricPh);
Ht = Entropy(MetricPt);
Hxt = Entropy(MetricPht);
I = Hx + Ht - Hxt;  % I(xt,xt-1) = H(xt) + H(xt-1) -H(xt,xt-1)
Max_I = max(Hx,Ht);
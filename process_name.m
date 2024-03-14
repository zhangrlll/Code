function [new_cell_array] = process_name(cell_array)
%PROCESS_NAME 此处显示有关此函数的摘要
%   此处显示详细说明
% 创建一个新的100x1的单元格数组来存储处理后的文字内容
new_cell_array = cell(size(cell_array));

% 遍历原始单元格数组
for i = 1:numel(cell_array)
    % 获取当前单元格的文字内容
    text = cell_array{i};
    
    % 使用正则表达式删除括号前的空格、括号及其内部的字符
    cleaned_text = regexprep(text, '\s*\([^)]*\)', '');
    
    % 存储处理后的文字内容到新的单元格数组
    new_cell_array{i} = cleaned_text;
end
end


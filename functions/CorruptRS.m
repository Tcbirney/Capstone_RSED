function [corrupted] = CorruptRS(codeWord, corruption, gf_matrix)
%This function randomly corrupts bits in locations specified by the user
m = 2^numel(gf_matrix(1,:)) - 1;
for i= 1:numel(codeWord)
    if corruption(i) == 1
        codeWord(i) = randi([0,m - 1]); 
    end
end
corrupted = codeWord;
end


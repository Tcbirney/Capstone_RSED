function [errorLoc] = convertErrorLoc(gf_matrix, codeWord, bitsIn, hexIn)
%LARGELY THE SAME AS convertGFPower. Takes in gf matrix, options of binary, or hex and converts to binary vector with '1' indicating error if
%necessary. unused input formats should hold -2. Hex format should be
%['A1','B1', 'FF'], bits [1 1 0 0]. CANNOT TAKE POWER NOTATION FOR ERROR
%LOCATION

[rows, cols] = size(gf_matrix);
m = cols; %m = numel(gf_matrix(1,:));
btemp = zeros(1, numel(bitsIn) + 1);       
numBits = numel(bitsIn);

%is it binary?
if bitsIn ~= -2
  
    %simulink didn't like how I padded with zeros
    %we want to crop or expand this to the size of the code word
    bitsCount = numel(bitsIn);
    if bitsCount < numel(codeWord)
        while bitsCount ~= numel(codeWord)
            bitsCount = bitsCount + 1;
        end
        btemp = zeros(1,bitsCount);
        btemp(1:numel(bitsIn)) = bitsIn;
        %bitsIn = btemp;
        errorLoc = btemp;
    elseif bitsCount > numel(codeWord)
        btemp = zeros(1, cols);
        btemp = bitsIn(1:numel(codeWord));
        errorLoc = btemp;
    end        

%is it hex?
elseif hexIn ~= -2
    
    %convert hex to binary manually for simulink
    bitsIn = zeros(1, numel(hexIn) * 4);
    bitsIndex = 1;
    for i2 = 1:numel(hexIn)
        hexVal = hexIn(i2);
        switch hexVal
            case '0'
                bitsIn(bitsIndex:bitsIndex + 3) = [0 0 0 0];
                bitsIndex = bitsIndex + 4;
            case '1'
                bitsIn(bitsIndex:bitsIndex + 3) = [0 0 0 1];
                bitsIndex = bitsIndex + 4;
            case '2'
                bitsIn(bitsIndex:bitsIndex + 3) = [0 0 1 0];
                bitsIndex = bitsIndex + 4;
            case '3'
                bitsIn(bitsIndex:bitsIndex + 3) = [0 0 1 1];
                bitsIndex = bitsIndex + 4;
            case '4'
                bitsIn(bitsIndex:bitsIndex + 3) = [0 1 0 0];
                bitsIndex = bitsIndex + 4;
            case '5'
                bitsIn(bitsIndex:bitsIndex + 3) = [0 1 0 1];
                bitsIndex = bitsIndex + 4;
            case '6'
                bitsIn(bitsIndex:bitsIndex + 3) = [0 1 1 0];
                bitsIndex = bitsIndex + 4;
            case '7'
                bitsIn(bitsIndex:bitsIndex + 3) = [0 1 1 1];
                bitsIndex = bitsIndex + 4;
            case '8'
                bitsIn(bitsIndex:bitsIndex + 3) = [1 0 0 0];
                bitsIndex = bitsIndex + 4;
            case '9'
                bitsIn(bitsIndex:bitsIndex + 3) = [1 0 0 1];
                bitsIndex = bitsIndex + 4;
            case 'A'
                bitsIn(bitsIndex:bitsIndex + 3) = [1 0 1 0];
                bitsIndex = bitsIndex + 4;
            case 'B'
                bitsIn(bitsIndex:bitsIndex + 3) = [1 0 1 1];
                bitsIndex = bitsIndex + 4;
            case 'C'
                bitsIn(bitsIndex:bitsIndex + 3) = [1 1 0 0];
                bitsIndex = bitsIndex + 4;
            case 'D'
                bitsIn(bitsIndex:bitsIndex + 3) = [1 1 0 1];
                bitsIndex = bitsIndex + 4;
            case 'E'
                bitsIn(bitsIndex:bitsIndex + 3) = [1 1 1 0];
                bitsIndex = bitsIndex + 4;    
            case 'F'
                bitsIn(bitsIndex:bitsIndex + 3) = [1 1 1 1];
                bitsIndex = bitsIndex + 4;                   
        end
    end
    
    %simulink didn't like how I padded with zeros
    %we want to crop or expand this to the size of the code word
    bitsCount = numel(bitsIn);
    if bitsCount < numel(codeWord)
        while bitsCount ~= numel(codeWord)
            bitsCount = bitsCount + 1;
        end
        btemp = zeros(1,bitsCount);
        btemp(1:numel(bitsIn)) = bitsIn;
        %bitsIn = btemp;
    elseif bitsCount > numel(codeWord)
        btemp = zeros(1, cols);
        btemp = bitsIn(1:numel(codeWord));
        %bitsIn = btemp;
    end  
    errorLoc = btemp;
else
    error('No input message provided :(')
end
end

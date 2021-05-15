function [powerNotation] = convertErrorVal(gf_matrix, bitsIn, hexIn, powers)
%LARGELY THE SAME AS convertGFPower. Takes in gf matrix, options of power notation, binary, or hex and converts to power notation if
%necessary. unused input formats should hold 'x'. Hex format should be
%['A1','B1', 'FF'], bits [1 1 0 0]
[rows, cols] = size(gf_matrix);
m = cols; %m = numel(gf_matrix(1,:));
btemp = zeros(1, numel(bitsIn) + 1);       
numBits = numel(bitsIn);

%is it already in power notation?
if powers ~= -2
    powerNotation = powers;
    return
    
%is it binary?
elseif bitsIn ~= -2
  
    %simulink didn't like how I padded with zeros
    %we want to crop or expand this to the size of a field element
    bitsCount = numel(bitsIn);
    if bitsCount < cols
        while bitsCount ~= cols
            bitsCount = bitsCount + 1;
        end
        btemp = zeros(1,numBits + bitsCount);
        btemp(1:numel(bitsIn)) = bitsIn;
        bitsIn = btemp;
    elseif bitsCount > cols
        btemp = zeros(1, cols);
        btemp = bitsIn(1:cols);
        bitsIn = btemp;
    end        

    %find the corresponding GF element
    for i1 = 1:rows
        if bitsIn == gf_matrix(i1,:)
            if i1 == 1
                powerNotation = Inf;
            else
                powerNotation = i1 - 2;%reverse indexing from above
            end
            break;
        end
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
    
    %we want to crop or expand this to the size of a field element
    bitsCount = numel(bitsIn);
    if bitsCount < cols
        while bitsCount ~= cols
            bitsCount = bitsCount + 1;
        end
        btemp = zeros(1,numBits + bitsCount);
        btemp(1:numel(bitsIn)) = bitsIn;
        bitsIn = btemp;
    elseif bitsCount > cols
        btemp = zeros(1, cols);
        btemp = bitsIn(1:cols);
        bitsIn = btemp;
    end        

    %find the corresponding GF element
    for i1 = 1:rows
        if bitsIn == gf_matrix(i1,:)
            if i1 == 1
                powerNotation = Inf;
            else
                powerNotation = i1 - 2;%reverse indexing from above
            end
            break;
        end
    end
    
else
    error('No input message provided :(')
end
end

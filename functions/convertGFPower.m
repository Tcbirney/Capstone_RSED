function [powerNotation] = convertGFPower(gf_matrix, bitsIn, hexIn, powers)
%Takes in gf matrix, options of power notation, binary, or hex and converts to power notation if
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
    
    %pad with zeroes if necessary
%     while mod(numel(bitsIn), m) ~= 0
%         btemp = zeros(1, numel(bitsIn) + 1);
%         btemp(1:numel(bitsIn)) = bitsIn;
%         bitsIn = btemp;
%     end 
    
    %simulink didn't like how I padded with zeros
    bitsCount = numel(bitsIn);
    while mod(bitsCount, m) ~= 0
        bitsCount = bitsCount + 1;
    end
    
    btemp = zeros(1,numBits + bitsCount);
    bitsIn = btemp;

    %how many GF powers are there
    numPowers = numel(bitsIn)/m;
    powerNotation = inf*ones(1,numPowers);
    powerIndex = 1;
    
    for i = 1:numPowers
        gfElement = bitsIn(1:3);

        %compare element with gf rows
         [rows, cols] = size(gf_matrix);

        for i1 = 1:rows %check each row of GF for matches
            if gfElement(1,:) == gf_matrix(i1,:)
                if i1 == 1
                    powerNotation(powerIndex) = Inf;
                else
                    powerNotation(powerIndex) = i1 - 2;%reverse indexing from above
                end
                break;
            end
        end
        powerIndex = powerIndex + 1;
        bitsIn = bitsIn(m+1:end);
    end
    
%is it hex?
elseif hexIn ~= -2
    
    %convert it to binary
    %bitsIn = hexToBinaryVector(hexIn);
    
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
    
    temp1 = zeros(1,numel(bitsIn));
    [row, col] = size(bitsIn);
    colIndex = 1;
    for i2 = 1:row
        for i3 = 1:col
            temp1(1, colIndex) = bitsIn(i2, i3);
            colIndex = colIndex + 1;
        end
    end
    
    bitsIn = temp1;
      
    %pad with zeroes if necessary
%     while mod(numel(bitsIn), m) ~= 0
%         temp = zeros(1, numel(bitsIn) + 1);
%         temp(1:numel(bitsIn)) = bitsIn;
%         bitsIn = temp;
%     end 

    %simulink didn't like how I padded with zeros
    bitsCount = numel(bitsIn);
    while mod(bitsCount, m) ~= 0
        bitsCount = bitsCount + 1;
    end
    
    btemp = zeros(1,numBits + bitsCount);
    bitsIn = btemp;
    
    %how many GF powers are there
    numPowers = numel(bitsIn)/m;
    powerNotation = Inf*ones(1,numPowers);
    powerIndex = 1;
    
    for i = 1:numPowers
        gfElement = bitsIn(1:3);

        %compare element with gf rows
         [rows, cols] = size(gf_matrix);

        for i1 = 1:rows %check each row of GF for matches
            if gfElement(1,:) == gf_matrix(i1,:)
                if i1 == 1
                    powerNotation(powerIndex) = Inf;
                else
                    powerNotation(powerIndex) = i1 - 2;%reverse indexing from above
                end
                break;
            end
        end
        powerIndex = powerIndex + 1;
        bitsIn = bitsIn(m+1:end);
    end
    
else
    error('No input message provided :(')
end
end
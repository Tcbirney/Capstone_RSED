function [powerNotation] = convertGFPower(gf_matrix, bitsIn, hexIn, powers)
%Takes in gf matrix, options of power notation, binary, or hex and converts to power notation if
%necessary. unused input formats should hold 'x'. Hex format should be ['A1';'B1']

m = numel(gf_matrix(1,:));

%is it already in power notation?
if powers ~= 'x'
    powerNotation = powers;
    return
    
%is it binary?
elseif bitsIn ~= 'x'
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
    
%is it hex?
elseif hexIn ~= 'x'
    
    %convert it to binary
    bitsIn = hexToBinaryVector(hexIn);
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
    while mod(numel(bitsIn), m) ~= 0
        temp = zeros(1, numel(bitsIn) + 1);
        temp(1:numel(bitsIn)) = bitsIn;
        bitsIn = temp;
    end 
    
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
    powerNotation = 0;
end

end


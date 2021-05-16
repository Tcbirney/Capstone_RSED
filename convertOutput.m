function [bits, hex, power] = convertOutput(gf_matrix, powers)
%Converts output from power notation to bits and hex
power = powers;
m = numel(gf_matrix(1,:));

power = powers;
    
%convert to binary
bits = zeros(1, numel(powers)*m);
bitsIndex = 1;

for i = 1:numel(powers)
    if powers(i) == Inf
        bits(1, bitsIndex:bitsIndex + (m - 1)) = gf_matrix(1, :);
    else
        bits(1, bitsIndex:bitsIndex + (m - 1)) = gf_matrix(powers(i) + 2, :);
    end
    bitsIndex = bitsIndex + m;
end
        
%pad with zeros for hex
%simulink didn't like how I padded with zeros
if mod(numel(bits), 4) ~= 0
    bitsCount = numel(bits);
    while mod(numel(bits), 4) ~= 0
        bitsCount = bitsCount + 1;
    end
    btemp = zeros(1,numBits + bitsCount);
    btemp(1:numel(bits)) = bits;
else
    btemp = bits;
end

%convert the padded binary to hex
%convert hex to binary manually for simulink
hex = blanks(numel(bits)/4);
hexIndex = 1;
for i2 = 1:4:numel(btemp)
    bitsVal = btemp(i2: i2 + 3);
    if isequal(bitsVal, [0 0 0 0])
        hex(hexIndex) = '0';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [0 0 0 1])
        hex(hexIndex) = '1';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [0 0 1 0])
        hex(hexIndex) = '2';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [0 0 1 1])
        hex(hexIndex) = '3';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [0 1 0 0])
        hex(hexIndex) = '4';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [0 1 0 1])
        hex(hexIndex) = '5';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [0 1 1 0])
        hex(hexIndex) = '6';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [0 1 1 1])
        hex(hexIndex) = '7';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [1 0 0 0])
        hex(hexIndex) = '8';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [1 0 0 1])
        hex(hexIndex) = '9';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [1 0 1 0])
        hex(hexIndex) = 'A';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [1 0 1 1])
        hex(hexIndex) = 'B';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [1 1 0 0])
        hex(hexIndex) = 'C';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [1 1 0 1])
        hex(hexIndex) = 'D';
        hexIndex = hexIndex + 1;
    elseif isequal(bitsVal,   [1 1 1 0])
        hex(hexIndex) = 'E';
        hexIndex = hexIndex + 1;    
    elseif isequal(bitsVal,   [1 1 1 1])
        hex(hexIndex) = 'F';
        hexIndex = hexIndex + 1;      
    end
end

end

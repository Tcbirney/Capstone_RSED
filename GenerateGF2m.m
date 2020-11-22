% GenerateGF2m: generates the selected Galois Field element. The inputs should be the
% order m and the coefficients of an appropriate primitive polynomial. The generated field,
% in either binary or power notation, may be a calling parameter for each of the other
% functions. Hint: I strongly suggest that you input the coefficients in “power” notation,
% with the highest order power on the left

function [fieldElements] = GenerateGF2m(m, primPoly) %primPoly in power notation, highest order on left

%determine where the taps are and write the power to an array
indxPwr = m;%power of alpha that is tap
tapIndx = 1;%where to store it
taps = zeros(1,m+1); %stores powers of alpha that are taps
for i0 = 2:m
    if primPoly(i0) == 1
        taps(tapIndx) = indxPwr; %note power is +1 because indexing starts at 1
        tapIndx = tapIndx + 1;
    end
    indxPwr = indxPwr - 1;
end

gf = zeros(2^m, m); %there are 2^m field elements
gfIndx = 2; %gfIndx(1) holds initial state 
numShifts = (2^m) - 1;
alphaPower = 1; 
isTap = 0;
s_reg = zeros(1,m);
s_reg(end) = 1; %rightmost element of init shr is 1
gf(1, :) = 0;%write the contents of the init shift register to the matrix of gf elements
gf(2, :) = s_reg;
for i = 2:numShifts %number of shifts corresponds to power of primitive element
    carryOut = s_reg(1);%save the value to be wrapped
    for j = 2:m %for each element in the shift register after the leftmost
        %check for taps
        for k = 1:numel(taps)%iterate through array of tap indices and see if that tap matches
            if taps(k) == j - 1 %if there's a tap xor and shift
                s_reg(j - 1) = xor(s_reg(j), carryOut);
                isTap = 1;
            end
        end
        if isTap == 0
            s_reg(j - 1) = s_reg(j);%shift that element left
        end
    alphaPower = alphaPower + 1;%inc/dec things
    end
    s_reg(m) = carryOut;
    isTap = 0;
    gf(i+1,:) = s_reg; %add the newly shifted register to the gf matrix
end
fieldElements = gf;
end
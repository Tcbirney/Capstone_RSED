function gf  = GenerateGF2m(primPoly, m) %primPoly in power notation, highest order on left

%m = 3;
% hard coded size of retrun matrices and gf mtrix because simulink
% whines about variable output size. Havent figured out how to fix it
% ask laberge
    %gf = zeros(8, m); %there are 2^m field elements
    gf = zeros(2^m, m); %there are 2^m field elements

    gfIndx = 2; %gfIndx(1) holds initial state 
    numShifts = (2^m) - 1;
    s_reg = zeros(1,m);
    s_reg(end) = 1; %rightmost element of init shr is 1
    gf(1, :) = 0;%write the contents of the init shift register to the matrix of gf elements
    gf(2, :) = s_reg;
    
    for i = 2:numShifts %number of shifts corresponds to power of primitive element
        carryOut = s_reg(1);%save the value to be wrapped
        for i0 = 1:numel(s_reg)-1
            if primPoly(i0 + 1) == 1
                s_reg(i0) = xor(carryOut, s_reg(i0 + 1));
            else
                s_reg(i0) = s_reg(i0 + 1);
            end
        end
        s_reg(end) = carryOut;
        gf(i+1,:) = s_reg; %add the newly shifted register to the gf matrix
    end
end
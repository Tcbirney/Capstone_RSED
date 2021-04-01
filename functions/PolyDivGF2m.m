% Divide two polynomials over GF(2m)[x] , returning both the quotient and
% the remainder. I expect that this function will use the previous functions, as necessary.
% Hint 1: I suggest using power notation for the calling parameters and the returned
% parameter. Hint 2: this will essentially do a deconvolution with arithmetic in the Big Field.
% The MATLAB routine deconv will not do the correct algebra and so should not be used!
function [q, r] = PolyDivGF2m(dividend, divisor, gf_matrix)
m = numel(gf_matrix(1,:));
numDivs = ((numel(dividend) - 1) - (numel(divisor) - 1)); %power of dividend - power of divisor
toSubtract = -1*ones(2, numel(divisor));
quotient = -1*ones(1, numDivs);
toSubtract(1,:) = dividend(1:numel(divisor)); %initialize for first subtraction
sub_res = -1*ones(1, (numel(divisor)));
bringDwn = numel(divisor) + 1;
divs = 0; %keep track of number of iteratiions

%for i = 1:numDivs %is this loop redundant?
    for j = 1:(numDivs + 1) %for each element in the divisor
        in1 = toSubtract(1, 1);
        in2 = divisor(1);
        quotient(1, j) = DivGF2m(in1, in2, gf_matrix);%divide the element
        for k = 1:numel(divisor)%multiply each element of dividend by quotient from prev step
            %need to do something about indexing for lower powers
            sIn1 = quotient(j);
            sIn2 = divisor(k);
            toSubtract(2, k) = MultGF2m(sIn1, sIn2, gf_matrix);
        end
        for i0 = 1:numel(divisor)%subtract
            sub_res(1,i0) = AddGF2m(toSubtract(1,i0), toSubtract(2, i0), gf_matrix);%perform the subtraction
        end
        toSubtract(1:end) = -1; %reinitialize toSubtract
        toSubtract(1, 1:numel(divisor) - 1) = sub_res(2:end); %assign the result to the next subtraction register
        if divs < numDivs %bring down number from dividend if applicable
            toSubtract(1, numel(divisor)) = dividend(bringDwn);
        end
        divs = divs + 1;
        bringDwn = bringDwn + 1;
    end
%end
r = sub_res(1,:);
q = quotient;
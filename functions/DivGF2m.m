%divides two elements of the Galois Field
%in1, in2, product in power notation MSB on the left
function [quotient] = DivGF2m(dividend, divisor, gf_matrix)
m = numel(gf_matrix(1,:));

if(dividend == -1)
    quotient = -1;
else
    sum = dividend - divisor;
    quotient = mod(sum, ((2^m) - 1));
end


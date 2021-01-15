%divides two elements of the Galois Field
%in1, in2, product in power notation MSB on the left
function [quotient] = DivGF2m(dividend, divisor, gf_matrix)
m = numel(gf_matrix(1,:));
if (divisor == inf)
    msg = 'ERROR: divisor cannot be INF';
    error(msg)
end
sum = dividend - divisor;
quotient = mod(sum, ((2^m) - 1)); 
isinf = isnan(quotient);
if isinf
    quotient = inf;
end
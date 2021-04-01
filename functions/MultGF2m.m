%multiplies two elements of the Galois Field
%in1, in2, product in power notation
function [product] = MultGF2m(in1, in2, gf_matrix)
%gf_matrix = GenerateGF2m(m, primPoly);


% if either one of the inputs are infinity (-1), then
% the product is infinity
% otherwise the product is mod(s, ((2^m) - 1))
if (in1 == -1 || in2 == -1)
    product = -1;
else
    m = numel(gf_matrix(1,:));
    s = in1 + in2;
    product = mod(s, ((2^m) - 1));
end

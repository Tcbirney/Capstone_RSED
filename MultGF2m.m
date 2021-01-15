%multiplies two elements of the Galois Field
%in1, in2, product in power notation
function [product] = MultGF2m(in1, in2, gf_matrix)
m = numel(gf_matrix(1,:));
%gf_matrix = GenerateGF2m(m, primPoly);
if in1 == inf
    product = inf;
elseif in2 == inf
    product = inf;
end
s = in1 + in2;
product = mod(s, ((2^m) - 1));%take answer modulo 2^m-1
isinf = isnan(product);
if isinf
    product = inf;
end
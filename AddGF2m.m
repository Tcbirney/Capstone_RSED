%adds two elements of the Galois Field
%in1, in2, and sum are in power notation, highest order on the left
function [sum] = AddGF2m(in1, in2)
sum = xor(in1, in2);
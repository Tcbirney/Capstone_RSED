% %Evaluate a polynomial over GF(2m)[x] , returning a single value for the
% evaluated polynomial.
%evaluating highest order on the left
%For example x^4 + a^3x^3 + x^2 + ax + a^3 is [0 3 0 1 3] 
function [eval] = EvalPolyGF2m(poly, x, gf_matrix)
m = numel(gf_matrix(1,:));
ctr = numel(poly) - 1;
i = 1;
exp = zeros(1, numel(poly));

while ctr >= 0 %make array of x exponents, highest power on the left
    exp(1, i) = ctr;
    i = i + 1;
    ctr = ctr - 1;
end

%check for INFs in poly
for i4 = 1:numel(poly)
    if poly(i4) == -1
        exp(i4) = -1;
    end
end

exp_res = zeros(1, numel(poly)); %holds values of x when evaluated at exponents in alpha power notation

%sub in x and evaluate each exponent
for j = 1:numel(poly)- 1 %for each power of x
    if x == -1
        res = -1;
    else
        res = exp(j) * x;
    end
    exp_res(j) = res;
end
exp_res(end) = poly(end);
mult_res = zeros(1, numel(poly));

%multiply each result by its corresponding alpha exponent
for i0 = 1:numel(poly)-1 %for each part of the polynomial
    m1 = exp_res(i0);
    m2 = poly(i0);
    p = MultGF2m(m1, m2, gf_matrix); %multiply a^power by x^power
    
    if (p == -1)
        mult_res(i0) = -1;
    else
        mult_res(i0) = p;
    end
end

mult_res(end) = poly(end);

%add all the results
eval = mult_res(1);
for i1 = 2:(numel(mult_res))
    in1 = mult_res(i1);
    in2 = eval;
    eval = AddGF2m(in1, in2, gf_matrix);
end
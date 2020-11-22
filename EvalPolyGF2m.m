% %Evaluate a polynomial over GF(2m)[x] , returning a single value for the
% evaluated polynomial.
%evaluating highest order on the left
%For example x^4 + a^3x^3 + x^2 + ax + a^3 is [inf 3 inf 1 3]
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

exp_res = zeros(1, numel(poly)); %holds values of x when evaluated at exponents in alpha power notation

%sub in x and evaluate each exponent
for j = 1:numel(poly) %for each power of x
    if exp(j) == 0
        res = 0;
    elseif exp(j) == 1
        res = x;
    elseif exp(j) == 2
        res = MultGF2m(x,x,gf_matrix);
    else
        res = MultGF2m(x,x,gf_matrix);
        for k = 3:exp(j)%multiply x however many times
            res = MultGF2m(res, x, gf_matrix);
        end
    end
    exp_res(j) = res;
end

mult_res = zeros(1, numel(poly));
isInf = 0;
%multiply each result by its corresponding alpha exponent
for i0 = 1:numel(poly) %for each part of the polynomial
    p = MultGF2m(exp_res(i0), poly(i0), gf_matrix); %multiply a^power by x^power
    isInf = isnan(p);
    if (isInf == 1)
        mult_res(i0) = inf;
    else
        mult_res(i0) = p;
    end
end

%add all the results
eval = mult_res(1);
for i1 = 2:(numel(mult_res))
    eval = AddGF2m(mult_res(i1), eval, gf_matrix);
end
function [errorPoly] = ForneyAlgorithmRS(lambda,syndromes,chien,gf_matrix)
%function to establish and find the roots of the Error Evaluator Polynomial
%omega = lambda*(s + 1)modx^
%multiply lambda by the syndrome + 1
msg = 'Executing Forney Algorithm...';
disp(msg);

indx = 1;
while lambda(indx) == Inf
    indx = indx + 1;
end

lambda = lambda(indx:numel(lambda));

modNum = 2^numel(gf_matrix(1,:)) - 1;

%flip syndromes (because it is reversed in berlekamp)
s_flipped = inf*ones(1,(numel(syndromes) + 1));
s_flipped(1:numel(syndromes)) = flip(syndromes);
s_flipped(end) = 0;
p = PolyMultGF2m(lambda, s_flipped, gf_matrix);

%ignore all terms with degree than r = n - k = 2t
[n, k] = size(gf_matrix);
[row_p, col_p] = size(p);
r = (n - 1) - k;
ix = col_p - r + 2;
omega = p(ix:end); %modulus
deriv = inf*ones(1,numel(omega));

printo = ['Omega: [', num2str(omega(:).'), ']'];
disp(printo);

%compute formal derivative
xpwr = 1;
derivIndx = numel(deriv);
for j = (numel(lambda) - 1):-1:1
    if xpwr == 1
        deriv(derivIndx) = lambda(j);
    elseif mod(xpwr, 2) == 0 %if it's even, the GF addition cancels
        deriv(derivIndx) = inf;
    else
        deriv(derivIndx) = lambda(j); %shift right
    end
    derivIndx = derivIndx - 1;
    xpwr = xpwr + 1;
end

errorPoly = inf*ones(1,chien(1)+1); 

%sub each Chien value into Forney's expression
for i0 = 1:numel(chien) %start at highest power
   intPoly = Inf*ones(1,numel(omega));    
   errorIndx = numel(errorPoly) - (chien(i0));
   negative = modNum - chien(i0); 
   coef = chien(i0) - deriv(end); %subtract outside alpha from denominator alpha
   
   xpwr = numel(omega) - 1;
   for i1 = 1:numel(omega) %for each term in omega
        intPoly(i1) = xpwr * negative; %evaluate x at the exponent
        intPoly(i1) = intPoly(i1) + omega(i1); %add that to the coefficient power (multiply)
        xpwr = xpwr - 1;
   end
   
   %distribute the new outside alpha and do mod
   for i2 = 1:numel(intPoly)
       intPoly(i2) = intPoly(i2) + coef;
       intPoly(i2) = mod(intPoly(i2), modNum);
   end
   
   %combine terms and solve
   for i3 = 1:numel(intPoly) %for each term
        for i4 = i3 + 1:numel(intPoly) %check the other terms to cancel
            if numel(intPoly) > 1
                if intPoly(i4) == intPoly(i3)
                    intPoly(i4) = [];
                    intPoly(i3) = [];
                end
             end
       end
   end
   
   if numel(intPoly) ~= 1
       eval1 = intPoly(1);
       for i5 = 2:numel(intPoly)
           eval1 = AddGF2m(eval1, intPoly(i5), gf_matrix);
       end
   else
       eval1 = intPoly(1);
   end
   
   errorPoly(errorIndx) = eval1;
%    eval = EvalPolyGF2m(omega, negative, gf_matrix); %eval omega at negative chien value
%    product = MultGF2m(chien(i0), eval, gf_matrix); %multiply result by positive chien value
%    derivEval = EvalPolyGF2m(deriv, negative, gf_matrix); %divide that by deriv evaluated at negative chien 
%    errorPoly(errorIndx) = PolyDivGF2m(product, derivEval, gf_matrix);
end
print = ['Error pattern: [', num2str(errorPoly(:).'), ']'];
disp(print);
end
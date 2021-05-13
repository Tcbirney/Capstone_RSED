function [errorPoly] = ForneyAlgorithmRS(lambda,syndromes,chien,gf_matrix,r)
%function to establish and find the roots of the Error Evaluator Polynomial
%omega = lambda*(s + 1)modx^
%multiply lambda by the syndrome + 1
%msg = 'Executing Forney Algorithm...';
%disp(msg);

indx = 1;
while lambda(indx) == -1
    indx = indx + 1;
end

lambda = lambda(indx:numel(lambda));

modNum = 2^numel(gf_matrix(1,:)) - 1;

%flip syndromes (because it is reversed in berlekamp)
s_flipped = -1*ones(1,(numel(syndromes) + 1));
s_flipped(1:numel(syndromes)) = flip(syndromes);
s_flipped(end) = 0;
p = PolyMultGF2m(lambda, s_flipped, gf_matrix);

%ignore all terms with degree than r = n - k = 2t
%[n, k] = size(gf_matrix);
[row_p, col_p] = size(p);
%r = (n - 1) - k;
ix = col_p - r + 2;
omega = p(ix:end); %modulus
deriv = -1*ones(1,numel(omega));

%printo = ['Omega: [', num2str(omega(:).'), ']'];
%disp(printo);

%compute formal derivative
errorPoly = -1*ones(1,chien(1)+1); 
xpwr = 1;
derivIndx = numel(deriv);
for j = (numel(lambda) - 1):-1:1
    if xpwr == 1
        deriv(derivIndx) = lambda(j);
    elseif mod(xpwr, 2) == 0 %if it's even, the GF addition cancels
        deriv(derivIndx) = -1;
    else
        deriv(derivIndx) = lambda(j); %shift right
    end
    derivIndx = derivIndx - 1;
    xpwr = xpwr + 1;
end

errorPoly = -1*ones(1,chien(1)+1); 

%chop -1s off deriv
i7 = 1;
while (deriv(i7) == -1)
    %find where to chop deriv
    i7 = i7 + 1;
end

%for simulink
derivTemp = deriv(i7:end);
deriv = derivTemp;

highestPwr = 0;
for i8 = 1:numel(chien)
    if chien(i8) > highestPwr
        highestPwr = chien(i8);
    end
end

errorPoly = -1*ones(1, highestPwr + 1); 

%chop "-1s" off left side of Omega
i6 = 1;
while (omega(i6) == -1)
    %find where to chop omega
    i6 = i6 + 1;
end

%for simulink
omegaTemp = omega(i6:end);
omega = omegaTemp;

%sub each Chien value into Forney's expression
for i0 = 1:numel(chien)
    %solve omega(-chien)
    errorIndx = numel(errorPoly) - (chien(i0));
    omegaVal = EvalPolyGF2m(omega, -chien(i0), gf_matrix);
    numerator = MultGF2m(omegaVal, chien(i0), gf_matrix);
    denominator = EvalPolyGF2m(deriv, -chien(i0), gf_matrix);
    errorPoly(errorIndx) = DivGF2m(numerator, denominator, gf_matrix);
end
end
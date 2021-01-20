function [corrected] = CorrectionRS(recPoly,errorPoly, gf_matrix)

%pad the error polynomial with inf if necessary
errorExp = inf*ones(1, numel(recPoly));
errorExp_i = numel(errorExp);
for j = numel(errorPoly):-1:1
    errorExp(errorExp_i) = errorPoly(j);
    errorExp_i = errorExp_i - 1;
end

%This function corrects a codeword polynomial given the error polynomial
corrected = inf*ones(1, numel(recPoly));
for i = 1: numel(corrected)
    corrected(i) = AddGF2m(recPoly(i), errorExp(i), gf_matrix);
end
    printres = ['The corrected word is: ', num2str(corrected(:).'), '. Decoding complete.'];
    disp(printres);
end
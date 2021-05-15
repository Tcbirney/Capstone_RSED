function cw = fcn(primPoly, m, recWord, cwOrig)

    gf = GenerateGF2m(primPoly, int8(m));
    
    cw = ones(1, numel(recWord));
    temp_cw = BerlekampMasseyRS(recWord, gf, cwOrig);
    
    if temp_cw ~= -2
        for i = 1:numel(recWord)
            cw(i) = temp_cw(i); 
        end
    else
        for i = 1:numel(recWord)
            cw(i) = temp_cw; 
        end
    end
end

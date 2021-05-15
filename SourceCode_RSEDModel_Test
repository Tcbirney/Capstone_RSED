function [encodedWord, corruptedWord] = RSED(primPoly, m, msgPoly, genPoly, corruptionVector, encodingMethod)
    gf = GenerateGF2m(primPoly, int8(m));
       
    codeWordLen = numel(msgPoly) + numel(genPoly) - 1;
    encodedWord = ones(1, codeWordLen);
    tempEncodedWord = ones(1, codeWordLen);
    
    if encodingMethod == 1
        tempEncodedWord = PolyMultGF2m(msgPoly, genPoly, gf);
    else
        tempEncodedWord = EncSystematicm(msgPoly, genPoly, gf);
    end
    
%     tempEncodedWord = PolyMultGF2m(msgPoly, genPoly, gf);
    
    for i = 1:codeWordLen
        encodedWord(i) = tempEncodedWord(i);
    end
    
    corruptedWord = CorruptRS(encodedWord, corruptionVector, gf);
end

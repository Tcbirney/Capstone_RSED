%function [c_hat_RS,failure] = BerlekampMasseyRS(gf_matrix, rec_word)
%This function implements the Berlekamp-Massey Algorithm for determining
%the Error Locator Polynomial for a given code word.
%inputs: GF2m matrix with binary coefficients
%received word polynomial in power notation (powers of alpha)
%output: the corrected word in power notation
function [errorLoc] = BerlekampMasseyRS(rec_word, gf_matrix, msg)
print = ['decoding ', num2str(rec_word(:).'), ' using Berlekamp-Massey Algorithm...'];
disp(print);
m = numel(gf_matrix(1,:));
n = (2^m) - 1;
[msgRow, k] = size(msg);
r = n - k; %changed from n - m
decFail = 0; %indicates decoder failure

%step 1
%compute the syndromes S1...Sr for the received codeword and form the
%syndrome polynomial
syndromes = zeros(1, r); %holds syndrome polynomial in alpha power notation, [S(1)....S(r)] 
for i = 1:r
    syndromes(i) = EvalPolyGF2m(rec_word, i, gf_matrix); %calculate each syndrome
end

if syndromes(1:end) == inf %if all syndromes are zero, no errors
   disp('No errors found. Berlekamp-Massey complete.');
   return;
end

k = 0;
L = 0;
tx = [0 inf]; %x, highest power on left
lambdaK = inf*ones(1, n+1);
lambdaK(end) = 0; %x
lambdaKm1 = lambdaK;

    while k < r
        %step 3**************************************************
        k = k + 1;
        %compute the big sum
            %multiply the things
            step3sum = inf; %initialize the sum
            lambdaIndx = numel(lambdaKm1) - 1;
            for i = 1:L 
                in1 = lambdaKm1(lambdaIndx); %should be 0 then 2
                in2 = syndromes(k - i); %should be 2 then inf
                p = MultGF2m(in1, in2, gf_matrix); %multiply lambda(k-1)by the k-ith syndrome
                isInf = isnan(p);
                if isInf == 1
                    p = inf;
                end
                step3sum = AddGF2m(step3sum, p, gf_matrix); %add multiplication result to big sum
                lambdaIndx = lambdaIndx - 1;
            end 
            deltaK = AddGF2m(syndromes(k), step3sum, gf_matrix); %compute the discrepancy  
        %end step 3**********************************************************
      
        %step 4
        if deltaK == inf %if deltaK == 0, step 8
            %step 8
            tx(numel(tx) + 1) = inf; %Shift T(x) to the left (higher power): T(x) = xT(x).
        else %otherwise step 5,6
            %step 5
            %modify connection polynomial
            product = PolyMultGF2m(deltaK, tx, gf_matrix);
            productIndx = numel(product);
            
            %figure out how many places there are to add
            if numel(product) < numel(lambdaKm1)
                numAdds = numel(product);
            else
                numAdds = numel(lambdaKm1);
            end
            
            lambdaK_i = numel(lambdaK); %we may need to have a temp array to store the addition if the product is longer than lambda. will this ever happen?
            for i1 = 1:numAdds %start from x^0 and move to higher powers adding each index
                lambdaK(lambdaK_i) = AddGF2m(lambdaKm1(lambdaK_i), product(productIndx), gf_matrix); 
                lambdaK_i = lambdaK_i - 1;
                productIndx = productIndx - 1;
            end
            %step 6
            if (2*L) >= k %if 2L>=k, step 8
                %step 8
                tx(numel(tx) + 1) = inf; %Shift T(x) to the left (higher power): T(x) = xT(x).            
            else %otherwise step 7 then step 8
                %step 7
                L = k - L;
                if lambdaKm1(1:end-1) == inf
                    tx = DivGF2m(lambdaKm1(end), deltaK, gf_matrix); %tx = delta(k-1)x/delta(k)
                else
                    tx = PolyDivGF2m(lambdaKm1, deltaK, gf_matrix); %tx = delta(k-1)x/delta(k)
                end
            
                %step 8
                tx(numel(tx) + 1) = inf; %Shift T(x) to the left (higher power): T(x) = xT(x).
            end
        end
        %update k - 1 variables
        lambdaKm1 = lambdaK;
        %deltaKm1 = deltaK;
    end
    
%     handle decoder failure
%     find the highest degree of lambda
%     degree = 0;
%     for i2 = 1:numel(lambdaK)
%         if lambdaK(i2) > degree && lambdaK(i2) ~= inf
%             degree = lambdaK(i2);
%         end
%     end
    i2 = numel(lambdaK);
    degree = -1; %to account for 0th degree
    while lambdaK(i2) ~= Inf
        i2 = i2 - 1;
        degree = degree + 1;
    end
    
    if degree > r %(r/2)
        decFail = 1;
        fail = '************DECODER FAILURE************';
        disp(fail);
    end

    %step 10
    %the error locator polynomial is the result of step k
    errorLoc = lambdaK;
    printres = ['the error locator polynomial is: ', num2str(errorLoc(:).'), '. Berlekamp-Massey complete.'];
    disp(printres);
    
    if decFail == 0
        %run chien and forney
        %print for debug
        chien = chienSearch(errorLoc, degree, gf_matrix);
        if chien ~= 'x'
            forney = ForneyAlgorithmRS(lambdaK,syndromes,chien,gf_matrix);
            CorrectionRS(rec_word,forney, gf_matrix)
        end
    end
    
end
        
        
        
        
        
        

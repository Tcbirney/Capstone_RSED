function corrupted  = CorruptRS(codeWord, posVector, errorRate, alphaPwr, gf_matrix)
%This function randomly corrupts bits in locations specified by the user.
%posVector is a vector containing '1' in the positions to corrupt and '0'
%in others. errorRate is the bit error rate (decimal), and alphaPwr is a
%power notation number specifying which alpha power the user would like to
%change the bit to.
%user inputs all zero vector to specify no position, and -2 for
%errorRate/alphaPwr if they would not like to specify

m = 2^numel(gf_matrix(1,:)) - 1;  
errorIndx = 0;
corrupted = codeWord;
%check parameters
if alphaPwr >= m
    fprintf('INVALID ERROR VALUE, please use a value less than 7.'); %value should be <2^m-1, change if gf changed
    
else
if errorRate == -2 %if the user doesn't specify a bit error rate (changed from 'x' to -2 for simulink)
    for i= 1:numel(codeWord)
        if posVector(i) == 1 %if there's a 1 in that place in the position vector
            if alphaPwr ~= -2 %and if the user has specified an error value
                if alphaPwr <= m %make sure the user's value is in the Galois Field
                    codeWord(i) = alphaPwr; %change the power at that position to the error value
                end
            else
                codeWord(i) = randi([0,m - 1]); %otherwise put a random power there
            end
        end
    end

else %bit error rate specification
    numErrors = 0; %for debug
    corruptIndices = zeros(1, numel(codeWord)); %keep track of where we've corrupted
    cIndex = 1;
    for j = 1:numel(codeWord)
        repeatCheck = 0;
        randNum = randi(100); 
        
        %if the random number is within the error rate, put error
        if randNum < errorRate*100
            numErrors = numErrors + 1; %debug;
            while (repeatCheck == 0)
     
                %generate random index for the error
                errorIndx = randi(numel(codeWord));
                
                %check if that index hasn't been used already
                for k = 1:numel(corruptIndices)
                    if errorIndx == corruptIndices(k)
                        break;
                    end
                    if k == numel(corruptIndices)
                        repeatCheck = 1;
                        corruptIndices(cIndex) = errorIndx;
                        cIndex = cIndex + 1;
                    end
                end 
            end
   
            %put in the error once we get the index
            if alphaPwr ~= -2
                codeWord(errorIndx) = alphaPwr;
            else
                codeWord(errorIndx) = randi([0,m - 1]); %otherwise put a random power there
            end
            
        end
        
    end
end
   corrupted = codeWord;
   %fprintf('Number of Errors: %int8\n', numErrors);
end

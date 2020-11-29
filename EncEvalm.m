% Encoding Evaluation Method
% Inputs:  Message polynomial, generatory polynomial, and gf_matrix
% Outputs: Returns codeword from using that method
% Example Input: EncEvalm([0 4 2],GenerateGF2m(3,[1 0 1 1]))

function [code_word] = EncEvalm(poly,gf_matrix)
m = numel(gf_matrix(1,:));  % set m to number of rows (power of 2)
numShifts = (2^m) - 1; 
ctr = 0;

% iteratet through each index of the codeword backwards 
for i = numShifts:-1:1
    % set codeword[index_num] to the evaluated polynomial at the
    % corresponding index
    % Note: codeword index goes down from 7-1 while ctr index goes up from
    % 0-6
    code_word(i) = EvalPolyGF2m(poly,ctr,gf_matrix);
    ctr = ctr+1;   % continue iterating ctr
end


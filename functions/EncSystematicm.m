% Systematic Encoding Method
% 1. Creates a temporary code word 
% 2. Uses polynomial division to find the remainder
% 3. Creates the codeword through polynomial addition
% Inputs: Message polynomial, generatory polynomial, and gf_matrix
% Output: Returns codeword from using that method
% Example Input: EncSystematicm([0 4 2],[0 3 0 1 3],GenerateGF2m(3,[1 0 1 1]))

function code_word  = EncSystematicm(poly,gen,gf_matrix)
m = numel(gf_matrix(1,:));  % set m to number of rows (power of 2)
numShifts = (2^m) - 1; 
power = numShifts - m; % find power which is n-k


x = ones(1: power+1);
x(power+1) =0;
% ask dona
% Filling the rest of the polynomial with inf
for i = (power+1):-1:2
    x(i) = -1;
end
% 
% % Shifting the temp polynomial 
temp_cw = PolyMultGF2m(x,poly,gf_matrix);

% temp_cw/gen = remainder 
% get the remainder
[q,r] = PolyDivGF2m(temp_cw,gen,gf_matrix);

% if the remainder array is smaller than the codeword array
if(numel(temp_cw) > numel(r))
    % find the offset between the codeword - remainder array
    diff = numel(temp_cw) - numel(r);
    % for the number of offsets
    for i = 1:diff
        % add infs to the left of the array
        r = [-1, r(1:end-1)];
    end
end


code_word = -1*ones(1, numShifts);
% Create the actual codeword using addition
% iterate through each index backwards
for i = numShifts:-1:1
        code_word(i) = AddGF2m(temp_cw(i),r(i),gf_matrix);
end


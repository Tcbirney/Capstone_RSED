function code_word = EncSystematicm(poly,gen,gf_matrix)
m = numel(gf_matrix(1,:)); % set m to number of rows (power of 2)
numShifts = (2^m) - 1;
power = numShifts - m; % find power which is n-k

% Initialize x array full of 0s
x = zeros(1,power+1);

% Filling everything but the first index with INF (-1)
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
temp_r = -1*ones(1,numShifts); % 1x7 array
counter = 1;
for i = 1:numShifts
if(i>diff)
temp_r(i) = r(counter);
counter = counter + 1;
end
end
end

% Initialize codeword full of 0s
code_word = zeros(1, numShifts);

% Create the actual codeword using addition
% iterate through each index backwards
for i = numShifts:-1:1
code_word(i) = AddGF2m(temp_cw(i),temp_r(i),gf_matrix);
end
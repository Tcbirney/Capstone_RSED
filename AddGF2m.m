%adds two elements of the Galois Field
%in1, in2 are binary coefficients of alpha powers, LSB on right
%sum is power notation
function [sum] = AddGF2m(in1, in2, gf_matrix)
m = numel(gf_matrix(1,:));
%convert power notation to rectangular
if in1 == inf
    sum = in2;
elseif in2 == inf
    sum = in1;
elseif in1 == in2
    sum = Inf; %changed
else
    gfIndx = in1 + 2; %account for inf and indexing
    r_in1 = gf_matrix(gfIndx, :);

    if in2 == inf
        r_in2 = zeros(1, m);
    else
        gfIndx = in2 + 2; %account for inf and indexing
        r_in2 = gf_matrix(gfIndx, :);
    end

    xor_res = xor(r_in1, r_in2); %xor the rectangular coordinates
    [rows, cols] = size(gf_matrix);

    for i = 1:rows %check each row of GF for matches
        if xor_res(1,:) == gf_matrix(i,:)
            if i == 1
                sum = Inf;
            else
                sum = i - 2;%reverse indexing from above
            end
            break;
        end
    end
end 
end

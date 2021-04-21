% Multiply two polynomials over GF(2m)[x] , with arithmetic in that field.
% I expect that this function will use the previous functions, as necessary. Hint 1: I suggest
% using power notation for the calling parameters and the returned parameter. Hint 2: this
% will essentially do a convolution with arithmetic in the Big Field. The MATLAB routine
% conv will not do the correct algebra and so should not be used!
function [polyProduct] = PolyMultGF2m(poly1, poly2, gf_matrix)
m = numel(gf_matrix(1,:));
offset = 0; 
rowIndx = 1;
power1 = numel(poly1)-1;% deg(poly1)
power2 = numel(poly2)-1;% deg(poly2)
colIndx = power1+power2+1;
toAdd = -1*ones(power2+1,colIndx); % (# elements poly2, total # elements)


for i = numel(poly2): -1: 1 %for each part of poly2 from right to left
    for j = numel(poly1(1,:)): -1: 1 %for each element of poly 1 from right to left
        
        % do we need the multGFM function if i can just check if either of
        % them are inf
        p = MultGF2m(poly2(i),poly1(j), gf_matrix);%multiply each element of poly1 by the poly2 element
        disp(p);
        if(p < 0)
            toAdd(rowIndx, colIndx - offset) = -1;
        else
            toAdd(rowIndx, colIndx - offset) = p;
        end
        colIndx = colIndx - 1;%go to next column (move left)
    end
    offset = offset + 1; %increment offset and row
    rowIndx = rowIndx + 1;
    colIndx = power1+power2+1; %reset column index to rightmost place
end
 
sum = -1*ones(1,power1+power2+1);
%add the rows from multiplication
[row, col] = size(toAdd);
sum(1,:) = toAdd(1, :);
for i0 = 2:(row) %for each row after the first
    for i1 = numel(sum):-1:1 %for each row element right to left
        in1 = toAdd(i0, i1);
        in2 = sum(1, i1);
        sum(1,i1) = AddGF2m(in1, in2, gf_matrix);%add that element and the corresponding first row element
    end
end
polyProduct = sum;
end

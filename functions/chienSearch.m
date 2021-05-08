function [errorPos] = chienSearch(lambda, degLambda, gf_matrix)
%msg = ['Executing Chien Search...'];
%disp(msg);
rootIndx = 1;
hasRoots = 0;
root_len = numel(lambda)-2;
roots = ones(1, root_len);
errorPos = ones(1, numel(roots));

    for i = 0: numel(roots)
        eval = EvalPolyGF2m(lambda, i, gf_matrix);
        if eval == -1
            roots(1, rootIndx) = i;
            rootIndx = rootIndx + 1;
            hasRoots = 1;
        end
    end
    numRoots = rootIndx - 1;
    if hasRoots == 1
        for i1 = 1:numel(roots)
            errorPos(i1) = DivGF2m(0, roots(i1), gf_matrix);
        end
        if numRoots < degLambda
            errorPos = 'x';
            %fail = ['DECODER FAILURE. THE NUMBER OF ROOTS IS LESS THAN THE DEGREE OF LAMBDA'];
            %disp(fail);
        end
        %rootPrint = ['roots found: [', num2str(roots(:).'),']'];
        %disp(rootPrint);
        %print = ['error locations: [' ,num2str(errorPos(:).'), ']'];
        %disp(print);
    else
        errorPos = 'x';
        %print = 'DECODER FAILURE: No roots found. LAMBDA is irreducible over the Galois Field';
        %disp(print);
    end
end

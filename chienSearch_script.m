primPoly = [1, 0, 1, 1];
m = 3;
lambda = [-1 -1 -1 -1 -1 5 2 0];
degree = 2;
gf = GenerateGF2m(primPoly, m);
chien = chienSearch(lambda, degree, gf);

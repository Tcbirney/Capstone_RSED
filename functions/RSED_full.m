primPoly = [1, 0, 1, 1];
m = 3;
msgPoly = [0, 4, 2];
genPoly = [0, 3, 0, 1, 3];
corruption_vector = [0, 0, 0, 1, 0, 0, 0];


gf = GenerateGF2m(primPoly, m)
encoded_word = PolyMultGF2m(msgPoly, genPoly, gf)
corrupted_word = CorruptRS(encoded_word, corruption_vector, gf)

decoded_word = BerlekampMasseyRS(corrupted_word, gf)


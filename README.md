# Capstone_RSED
Reed Solomon Encoder Decoder Capstone 2020/2021 Project
GenerateGF2m
This function generates elements of the Galois Field given an order and primitive 	
Polynomial. The output is a matrix of field elements in power notation. My function first determines which powers of alpha are taps and stores those indices in an array. I used a for loop to check which indices were one, then saved the corresponding power (+ 1 because MATLAB indexing starts at 1) to the taps array. I then initialized the shift register with m elements to all zeros except the rightmost index as one. To generate the elements of the Galois Field I implemented a linear feedback shift register. My function shifts the feedback register 2^m-1 times, each time saving the shift register contents to a new row of the output matrix. The bits are either shifted left or XOR-ed then shifted based on whether there is a tap at that shift (as determined by the input polynomial).

 

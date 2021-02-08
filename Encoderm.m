% Main driver program which prompts the user for their encoding method
% and returns the corresponding code word generated by that method.
% Inputs: Requires the message polynomial, generator polynomial and
% gf_matrix
% Output: Returns the codeword associated with the chosen encoding method
% Example Input: Encoderm([0 4 2],[0 3 0 1 3],GenerateGF2m(3,[1 0 1 1]))

function [code_word] = Encoderm(m_poly,gen_poly,gf_matrix)

% prompt user for their encoding method
prompt = 'Which method would you like to use? \nEnter 1 for Evaluation Method.\nEnter 2 for Generator Polynomial Method. \nEnter 3 for Systematic Method.\n ';
x = input(prompt)

msg = 'Error: Invalid Selection. Please Try Again\n';

% error checking the user input
while ((x < 1) || (x > 2))
    fprintf(msg);
    x = input(prompt) %reprompt user until they provide a valid input
end

fprintf('Final Codeword is: \n')

% Call Generator Polynomial Method (calling multiplication) if user input = 1
elseif x==1
    code_word = PolyMultGF2m(m_poly,gen_poly,gf_matrix)
% Call Systematic Method if user input = 2
elseif x==2
    code_word = EncSystematicm(m_poly,gen_poly,gf_matrix)

end

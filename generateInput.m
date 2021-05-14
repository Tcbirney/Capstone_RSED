function [msg] = generateInput(msgLen, m)
%generates input of specified length
msg = randi([-1 ((2^m) - 1)],1,msgLen);
end


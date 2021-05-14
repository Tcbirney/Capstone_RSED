function [errorRate] = BER(encoderOutput,decoderOutput)
%computes the post-correction bit error rate
errorRate = 0;
if numel(encoderOutput) ~= numel(decoderOutput)
    errorRate = -2;
else
    for i = 1:numel(encoderOutput)
        if encoderOutput(i) ~= decoderOutput(i)
            errorRate = errorRate + 1;
        end
    end
end


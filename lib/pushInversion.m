function [outputArray] = pushInversion(inputArray)
%PUSHINVERSION# Summary of this function goes here
%   Detailed explanation goes here

outputArray = inputArray;
for k = 1:size(outputArray,2)
    if(mod(k,2) == 1)
        outputArray{1,k} = -1*outputArray{1,k};
    end
end


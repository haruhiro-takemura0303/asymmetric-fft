function [y] = readArray(inputArray)
%READARRAY Summary of this function goes here
%   Detailed explanation goes here
y = [];

for k = 1:size(inputArray,2)
    y = cat(2,y,inputArray{1,k});        
end
end


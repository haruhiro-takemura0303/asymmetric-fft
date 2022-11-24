function [outputNoise,outputArray] = noiseSplitPull(inputArray,inputNoise,shift)
%HELL Summary of this function goes here
%   Detailed explanation goes here
outputArray = cell(1,size(inputArray,2)*2);
outputNoise = cell(1,size(inputArray,2)*2);

if(nargin == 2)
   shift = 0; 
end

for k = 1:size(inputArray,2)
    [~,index] = min(abs(diff(diff(inputArray{1,k}))));
    index = index + 1;
    outputArray{1,2*(k-1)+1} = inputArray{1,k}(1:index+shift);
    outputArray{1,2*k} = inputArray{1,k}(index+1+shift:size(inputArray{1,k},2));
    outputNoise{1,2*(k-1)+1} = inputNoise{1,k}(1:index+shift);
    outputNoise{1,2*k} = inputNoise{1,k}(index+1+shift:size(inputArray{1,k},2));
end
    outputArray{1,2} = [outputArray{1,1}(end),outputArray{1,2}];
    outputNoise{1,2} = [outputNoise{1,1}(end),outputNoise{1,2}];
end


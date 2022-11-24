function [y_reconstruct] = sineReconstruct(signal,Fs,n)
%SINERECONSTRUCT Reconstructs the signal automatically according to
%reconstruction algorithm
%   signal: To be analyzed signal;
%   Fs : Sampling Frequency
%   n: Index: (1) for Push, (2) for Pull
switch n
    case 1 
      y_reconstruct = readArray(pushInversion(SeparateMotion(Fs,signal,n)));  
    case 2
      y_reconstruct = readArray(pullInversion(SeparateMotion(Fs,signal,n)));  
    otherwise
        disp('Please insert (1) for Push or (2) for Pull-reconstruction');
end


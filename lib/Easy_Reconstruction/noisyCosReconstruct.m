function [y_reconstruct] = noisyCosReconstruct(noise_signal,guide_signal,Fs,n)
%NOISYSINERECONSTRUCT Reconstructs the noisy signal automatically according to
%reconstruction algorithm
%   noisy_signal: To be analyzed noisy signal
%   guide_signal: Guidance signal in order to stabilize the noisy
%   components
%   Fs : Sampling Frequency
%   n: Index: (1) for Push, (2) for Pull
switch n
    case 1
        y_reconstruct = readArray(pushInversion(NoiseSeparateMotion(Fs,guide_signal,noise_signal,n)));
    case 2
         y_reconstruct = readArray(pullInversion(NoiseSeparateMotion(Fs,guide_signal,noise_signal,n)));
    otherwise
end


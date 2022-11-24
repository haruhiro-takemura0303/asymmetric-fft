function [y,t] = createSineSample(frequency,samplingFreq,amplitude,number_samples)
%CREATESINESAMPLE Creates a sine-wave with a limited number of samples
f = frequency; 
Fs = samplingFreq;                           
amp = amplitude;
N = number_samples; 

t = (0:N-1)/Fs;           
y = amp*sin(2*pi*f*t);
end


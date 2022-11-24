function [y,t] = createCos(frequency,samplingFreq,amplitude,counter_period)
%CREATESINE Creates a sine-wave with start and end point at 0.
f = frequency; 
Fs = samplingFreq;       
k = counter_period;                       
amp = amplitude;
N = floor((Fs/f)*k+1);  

t = (0:N-1)/Fs;           
y = amp*cos(2*pi*f*t);
end

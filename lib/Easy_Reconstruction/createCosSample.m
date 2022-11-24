function [y,t] = createCosSample(amplitude,frequency,samplingFreq,countCycle)
%CREATESINESAMPLE Creates a cos-wave with a limited number of samples
f = frequency; 
Fs = samplingFreq;                           
amp = amplitude;
k = countCycle; 

Amp=amplitude; %振幅
T=(1/f)*k;

% t = linspace(0,T,Fs*T);
  t = 0:1/Fs:T;
y = amp*cos(2*pi*f*t);
end

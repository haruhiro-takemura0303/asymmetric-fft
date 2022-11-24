clc
clear all
close all

%Normalize a signal using interpolation an analyze it with signal
%reconstruction
F = 5000;
Fs = 48e3;
FsI =10*48e3;
Fup=lcm(Fs,FsI)/Fs;
Fdun=lcm(Fs,FsI)/FsI;
amp = 1;
k = 5000;

%Create time, signal and interpolated time samples
[signal,t] = createCos(F,Fs,amp,k+2);% "k+2" remove two interval in Reshape section
[y,tI] = createCos(F,FsI,amp,k);  


%% Old Interpolation-methods
% signalI = spline(t,signal,tI);
% signalI = sinc_interp(t,signal,tI);
% signalI=resample(signal,FsI,Fs);
% signalI = trig_interp(t,signal,tI);
% signalI = makima(t,signal,tI);
% signalI = pchip(t,signal,tI);

%% RESAMPLEING
[signalI,b]=interp(signal,Fup,5,0.4);
% signalI=decimate(signalI,Fdun);
signalI=signalI(1:end-1);

%% Reconstruct
%Removed the effect of the transient range of the filter.
[signalI_push] = SeparateMotion(FsI,signalI,1);
[signalI_pull] = SeparateMotion(FsI,signalI,2);

signalI_push = readArray(pushInversion(signalI_push(2:end-1))); % remove First and Last push interval
signalI_pull = readArray(pullInversion(signalI_pull(2:end-1))); % remove First and Last pullinterval
  
% % %% Reconstruct signal components
% signalI_push = cosReconstruct(signalI,FsI,1);
% signalI_pull = cosReconstruct(signalI,FsI,2);
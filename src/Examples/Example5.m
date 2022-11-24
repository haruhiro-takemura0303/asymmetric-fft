clc
clear all 
close all

%%data analysis%%%%%

% pramater
amp=1;F=500; Fs=48e3; k=10;

%% make simi_liner signal%%%%%

%make noise liner data
[y,t]=createCosSample(amp,F,Fs,k);

noise = wgn(1,length(y),-60);
noise_signal = y + noise;

%make semiliner signal
[y,t]=createCosSample(amp,F,Fs,k);

[nonlinear_push,linear_push] = NoiseSeparateMotion(Fs,y,noise_signal,1);
[nonlinear_pull, linear_pull] = NoiseSeparateMotion(Fs,y,noise_signal,2);

semi_linear_signal = readArray(nonlinearSwap(linear_push,nonlinear_pull,1));

%% analysis
signal_push = noisyCosReconstruct(semi_linear_signal,y,Fs,1);
signal_pull = noisyCosReconstruct(semi_linear_signal,y,Fs,2);

semi_linear_signal = readArray(nonlinearSwap(linear_push,nonlinear_pull,1));
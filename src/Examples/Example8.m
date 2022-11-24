clc
clear all 
close all

%%data analysis%%%%%

% pramater
F=1000; Fs=48e3; k=F;

%Load and reshape  nonlinear wave form 
data=load('data/2021.10.01/cos_1000.mat');
[signal,time,amp] = reshapedata(data,Fs,F,k);
signal=signal';

% %Reconstruct Push-signal
% signal_push = cosReconstruct(signal,Fs,1);
% %Reconstruct Pull-singal
% signal_pull = cosReconstruct(signal,Fs,2);

[gaide,t] = createCosSample(amp,F,Fs,k);
signal_push = noisyCosReconstruct(signal,gaide,Fs,1);
signal_pull = noisyCosReconstruct(signal,gaide,Fs,2);



% %%make simi_liner signal%%%%%
% 
% %make nonliner data
% nonlinear_push = SeparateMotion(Fs,signal,1,F);
% nonlinear_pull = SeparateMotion(Fs,signal,2,F);
% 
% %make liner data
% [y,t]=createCosSample(amp,F,Fs,k);
% linear_push = SeparateMotion(Fs,y,1,F);
% linear_pull = SeparateMotion(Fs,y,2,F);
% 
% figure(1)
% hold on
% plot(signal);
% plot(y);
% hold off
% xlabel('sample');ylabel('Amplitude')
% 
% %make semiliner signal
% semi_linear_signal = readArray(nonlinearSwap(linear_pull,nonlinear_push,1));
% 
% signalI_push = cosReconstruct(semi_linear_signal,Fs,1);
% signalI_pull = cosReconstruct(semi_linear_signal,Fs,2);

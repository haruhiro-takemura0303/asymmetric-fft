clc
close all
clear all

%%% Create a pseudo-nonlinear signal to verify the operation of the algorithm.

% pramater
amp=0.8555;F=1000; Fs=48e3; k=1000;

%% make simi_liner signal

% %make noise linear data
% y = createCos(F,Fs,amp,k+1);
% noise = wgn(1,length(y),-25);
% nonlinear_signal = y + noise;

%make nonliner liner data
[y,t]=createCosSample(amp,F,Fs,k+1); %cut out 1cycle later
% y = int16(y * 32768);
% y = double(y) ./ 32768 ;
% % signal=signal';

kd=6; D2=-70; N=13; 
nonlinear_signal = distorion(kd,D2,N,y);

%make semilinear signal
[nonlinear_push,linear_push] = NoiseSeparateMotion(Fs,y,nonlinear_signal,1);
[nonlinear_pull, linear_pull] = NoiseSeparateMotion(Fs,y,nonlinear_signal,2);

pull=nonlinear_pull;
push=linear_push;
semi_linear_signal = readArray(nonlinearSwap(pull,push,1));

clear nonlinear_push linear_push nonlinear_pull linear_pull

%reshape data
margin=length(pull{1,length(pull)})+ length(push{1,length(push)}); %sampule number of last 1cycle
last=length(semi_linear_signal)-margin+1;
semi_linear_signal=semi_linear_signal(1:last);

%% make audio write
% audiowrite('test.wav',semi_linear_signal,Fs);
% [semi_linear_signal,Fs] = audioread('test.wav');

%% Reconstruct

% %noise Reconstruction
% y=y(1:last)
% signal_push = noisyCosReconstruct(semi_linear_signal,y,Fs,1);
% signal_pull = noisyCosReconstruct(semi_linear_signal,y,Fs,2);

% %normal Reconstruction
% signal_push = cosReconstruct(semi_linear_signal,Fs,1);
% signal_pull = cosReconstruct(semi_linear_signal,Fs,2);

% semi_linear_signal=semi_linear_signal;

semi_linear_signal=nonlinear_signal;
[push_separete,pull_separete] = dataSepatateMotion(Fs,semi_linear_signal',F,k-2);

signal_push=readArray(pushInversion(push_separete));
signal_pull=readArray(pullInversion(pull_separete));


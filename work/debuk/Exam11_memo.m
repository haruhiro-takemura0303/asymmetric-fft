clear all
close all


%% pramater
Fs=48e3;
T=0.1;
F=1000;
k=1000;

data=load('data/2021.12.08/cos_1000.mat');
[data,time,amp] = reshapedata(data,Fs,F,k);


%% make simi_liner signal

% make nonliner data
[nonlinear_push,nonlinear_pull] = dataSepatateMotion(Fs,data,F,k);

% make liner data
[signal,t] = createCosSample(amp,F,Fs,k);
audiowrite('linear.wav',signal,Fs,'BitsPerSample',16);
[signal,Fs]=audioread('linear.wav');
signal=signal';

linear_push = SeparateMotion(Fs,signal,1);
linear_pull = SeparateMotion(Fs,signal,2);

% make semiliner deata
pull=nonlinear_pull;
push=linear_push;

semi_linear_signal = readArray(nonlinearSwap(pull,push,1));

% clear nonlinear_push linear_push nonlinear_pull linear_pull
%
% %reshape data
% margin=length(pull{1,length(pull)})+ length(push{1,length(push)}); %sampule number of last 1cycle
% last=length(semi_linear_signal)-margin+1;
% semi_linear_signal=semi_linear_signal(1:last);


%% Reconstruct
[push_separete,pull_separete] = dataSepatateMotion(Fs,semi_linear_signal',F,k-2);

signal_push=readArray(pushInversion(push_separete));
signal_pull=readArray(pullInversion(pull_separete));

% %noise Reconstruction
% y=y(1:last)
% signal_push = noisyCosReconstruct(semi_linear_signal,y,Fs,1);
% signal_pull = noisyCosReconstruct(semi_linear_signal,y,Fs,2);
% 
% % %normal Reconstruction
% % signal_push = cosReconstruct(semi_linear_signal,Fs,1);
% % signal_pull = cosReconstruct(semi_linear_signal,Fs,2);
% 

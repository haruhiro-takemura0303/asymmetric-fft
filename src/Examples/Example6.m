clear all
close all


%% pramater
Fs=48e3;
F=1000;
k=1000;

data=load('data/2021.12.08/cos_1000.mat');
[data,time,amp] = reshapedata(data,Fs,F,k);


%% make simi_liner signal

% make nonliner data
[nonlinear_push,nonlinear_pull] = dataSepatateMotion(Fs,data,F,k);

% make liner data
[signal,t] = createCosSample(amp,F,Fs,k);
% signal = signal(1:end-1);
% signal_16 = int16(signal * 32768);
% signal = double(signal_16) ./ 32768 ;
% signal=signal;

linear_push = SeparateMotion(Fs,signal,1);
linear_pull = SeparateMotion(Fs,signal,2);

% make semiliner deata
pull=nonlinear_pull;
push=linear_push;

semi_linear_signal = readArray(nonlinearSwap(pull,push,1));

%% make audio write
% audiowrite('test.wav',semi_linear_signal,Fs);
% [semi_linear_signal,Fs] = audioread('test.wav');
 
semi_linear_signal=semi_linear_signal';

%% Reconstruct
[push_separete,pull_separete] = dataSepatateMotion(Fs,semi_linear_signal,F,k-2);

signal_push=readArray(pushInversion(push_separete));
signal_pull=readArray(pullInversion(pull_separete));


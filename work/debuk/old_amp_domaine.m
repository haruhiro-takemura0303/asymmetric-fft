clc
close all
clear all

%%% Create a pseudo-nonlinear signal to verify the operation of the algorithm.

% pramater
amp=1;F=1000; Fs=48e3; k=1000;

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

%% Invension

signal=y;
signald=nonlinear_signal;

cell_push=NoiseSeparateMotion(Fs,signal,signald,1,F);
cell_pull=NoiseSeparateMotion(Fs,signal,signald,2,F);


signal_pull = readArray(cell_pull);
signal_push = readArray(cell_push);


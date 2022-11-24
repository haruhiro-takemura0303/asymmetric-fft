clc
clear all


% This Example shows the basic use of the algorithm

f = 1000;       %Frequency = 1 kHz
Fs = f*48;    %Sampling rate = 44.1 kHz     
k = 1000;       %Signal with 2000 periods
amp = 1;        %Signal amplitude of 1
N = floor((Fs/f)*k +1);  %Create amount of samples
t = (0:N-1)/Fs;          %Create time samples
signal = amp*cos(2*pi*f*t); %Create signal

%Push-Reconstruction
signal_push = readArray(pushInversion(SeparateMotion(Fs,signal,1)));

%Pull-Reconstruction
signal_pull = readArray(pullInversion(SeparateMotion(Fs,signal,2)));
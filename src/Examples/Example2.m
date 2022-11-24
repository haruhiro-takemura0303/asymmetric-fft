clc
clear all
close all

% This Example shows the simplified use of the algorithm

f = 500;       %Freqency of 1 kHz
Fs = 48000;     %Frequency of 48 kHz
k = 10;       %Amount of periods
amp = 10;        %Amplitude of 1

%Create Sine-Wave
[signal,time] = createCos(f,Fs,1,k);
%signal = createSine(f,Fs,1,k);      %Alternative to only get the signal

%Reconstruct Push-signal
signal_push = cosReconstruct(signal,Fs,1);
%Reconstruct Pull-singal
signal_pull = cosReconstruct(signal,Fs,2);
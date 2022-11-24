clc
clear all;
close all;


% This Example shows the simplified use of the algorithm to analyse a
% noisy signal with the help of a artificial sine-wave

F = 500;       %Frequency of 1 kHz
Fs = 48000;     %Frequency of 48 kHz;
k = 10;       %Amount of periods: 2000
amp = 1;      %Amplitude of 2.5

guide_signal = createCosSample(amp,F,Fs,k);

noise = wgn(1,length(guide_signal),-25,'dBW');
noise_signal = guide_signal + noise;

signal_push = noisyCosReconstruct(noise_signal,guide_signal,Fs,1);
signal_pull = noisyCosReconstruct(noise_signal,guide_signal,Fs,2);
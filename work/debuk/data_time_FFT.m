
clear all
%% Create sample
f = 1000;       %Freqency of 1 kHz
Fs = 48000;     %Frequency of 48 kHz
k = 100;       %Amount of periods
amp = 10;        %Amplitude of 1
[signal,time] = createCos(f,Fs,1,k);

%% make distortion

[signal,time] = createCos(f,Fs,1,k);

Kd = 6;
gain2 = -80;
hnumber = 10;
data = signal; 

%Create Cos-Wave
signald = distorion(Kd,gain2,hnumber,data);

run('synthesize_time_doman.m');


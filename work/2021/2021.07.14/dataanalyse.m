
clc
clear all;
close all;

run color.m
data=load('cos_1000_48_1.mat');

timed=data.Scope{4,1};
signald=data.Scope{4,2};


[pks,locs] = findpeaks(signald);

start=locs(1);

signal=signald(start:start+192*100);
time=timed(start:start+192*100);



% This Example shows the simplified use of the algorithm to analyse a
% noisy signal with the help of a artificial sine-wave

f = 1000;       %Frequency of 1 kHz
Fs = 192000;     %Frequency of 48 kHz;
k = 100;       %Amount of periods: 2000
amp = 15.9;      %Amplitude of 2.5

guide_signal = createCos(f,Fs,amp,k);

noise_signal = signal';

signalI_push = noisyCosReconstruct(noise_signal,guide_signal,Fs,1);
signalI_pull = noisyCosReconstruct(noise_signal,guide_signal,Fs,2);


figure(2)
L=length(signalI_push);
Y = fft(signalI_push);
P2 = abs(Y/L);
P1_s = P2(1:L/2+1);
P1_s(2:end-1) = 2*P1_s(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,mag2db(P1_s),'Linewidth',1.3,'Color',BLU)
% ylim([-90,0]);
xlim([0,20e3]);
title('Push_resample')
xlabel('f [Hz]')
ylabel('Power[db]')


figure(3)
L=length(signalI_pull);
Y = fft(signalI_pull);
P2 = abs(Y/L);
P1_l = P2(1:L/2+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,mag2db(P1_l),'Linewidth',1.3,'Color',ORG)
% ylim([-90,0]);
xlim([0,20e3]);
title('Push_resample')
xlabel('f [Hz]')
ylabel('Power[db]')


figure(4)
hold on
plot(f,mag2db(P1_s),'Linewidth',1.3,'Color',ORG)
plot(f,mag2db(P1_l),'Linewidth',1.3,'Color',BLU)
title('Push・Pull')
legend('Push','Pull')
xlim([0,20e3]);
title('Push_resample')
xlabel('f [Hz]')
ylabel('Power[db]')

hold off

figure(5)
plot(f,mag2db(P1_s)-mag2db(P1_l),'Linewidth',1.3,'Color',BLU)
title('Push・Pull')
legend('Push','Pull')
xlim([0,20e3]);
title('Push_resample')
xlabel('f [Hz]')
ylabel('Power[db]')
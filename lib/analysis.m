clc
clear all;
close all;

Fs=48*1000; %録音時のサンプリング周波数


% run color.m
data=load('2021.08.11/cos_1000_48k.mat');
data=struct2cell(data);


datan=data{1,1};
timed=datan{4,1};
signald=datan{4,2};


[pks,locs] = findpeaks(signald);

start=locs(1);

signal=signald(start:start+100*10);
time=timed(start:start+100*10);



% This Example shows the simplified use of the algorithm to analyse a
% noisy signal with the help of a artificial sine-wave

f = 1000;       %Frequency of 1 kHz
Fs = 192000;     %Frequency of 48 kHz;
k = 100;       %Amount of periods: 2000

signal=signal';

% %Push-Reconstruction
% signal_push = readArray(pushInversion(SeparateMotion(Fs,signal,1)));
% 
% %Pull-Reconstruction
% signal_pull = readArray(pullInversion(SeparateMotion(Fs,signal,2)));
% 




% figure(2)
% L=length(signal_push);
% Y = fft(signal_push);
% P2 = abs(Y/L);
% P1_s = P2(1:L/2+1);
% P1_s(2:end-1) = 2*P1_s(2:end-1);
% f = Fs*(0:(L/2))/L;
% plot(f,mag2db(P1_s),'Linewidth',1.3,'Color',BLU)
% % ylim([-90,0]);
% xlim([0,20e3]);
% title('Push_resample')
% xlabel('f [Hz]')
% ylabel('Power[db]')
% 
% 
% figure(3)
% L=length(signal_pull);
% Y = fft(signal_pull);
% P2 = abs(Y/L);
% P1_l = P2(1:L/2+1);
% P1_l(2:end-1) = 2*P1_l(2:end-1);
% f = Fs*(0:(L/2))/L;
% plot(f,mag2db(P1_l),'Linewidth',1.3,'Color',ORG)
% % ylim([-90,0]);
% xlim([0,20e3]);
% title('Push_resample')
% xlabel('f [Hz]')
% ylabel('Power[db]')
% 
% 
% figure(4)
% hold on
% plot(f,mag2db(P1_s),'Linewidth',1.3,'Color',ORG)
% plot(f,mag2db(P1_l),'Linewidth',1.3,'Color',BLU)
% title('Push・Pull')
% legend('Push','Pull')
% xlim([0,20e3]);
% title('Push_resample')
% xlabel('f [Hz]')
% ylabel('Power[db]')
% 
% hold off
% 
% figure(5)
% plot(f,mag2db(P1_s)-mag2db(P1_l),'Linewidth',1.3,'Color',BLU)
% title('Push・Pull')
% legend('Push','Pull')
% xlim([0,20e3]);
% title('Push_resample')
% xlabel('f [Hz]')
% ylabel('Power[db]')
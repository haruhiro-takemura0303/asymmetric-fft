%% run
run distortion_asyn_diffangle.m
run color.m

%% param
% signal_all=signald(1:end-1);
% signal_all=semi_linear_signal(193:47520);
signal_all=signald21;

signal_pull=signal_pull;
signal_push=signal_push;


%% figure
%% PULL FIGURE
figure(1)

L=length(signal_pull);
Y = fft(signal_pull); 
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

plot(f,mag2db(P1),'Linewidth',2.0)

title('Pull resample')
xlabel('f [Hz]')
ylabel('Power[db]')

ylim([-350,0])
xlim([0,24e3])

ax=gca;
ax.ColorOrder=BLU
ax.FontSize=10;

% saveas(gcf,'.\wav_amp_nonpull\Pull.png')

%% PUSH FIGURE
figure(2)
L=length(signal_push);
Y = fft(signal_push);
P2 = abs(Y/L);
P1_s = P2(1:L/2+1);
P1_s(2:end-1) = 2*P1_s(2:end-1);
f_s = Fs*(0:(L/2))/L;
plot(f_s,mag2db(P1_s),'Linewidth',2.0)
title('Push resample')
xlabel('f [Hz]')
ylabel('Power[db]')

 ylim([-350,0])
 xlim([0,24e3])

ax=gca;
ax.ColorOrder=ORG
ax.FontSize=10;
% saveas(gcf,'.\wav_amp_nonpull\Push.png')

%% DIFFRENT PULL・PUSH
figure(3)
hold on
plot(f,mag2db(P1),'Linewidth',2.2)
plot(f_s,mag2db(P1_s),'Linewidth',1.4)
title('Difference')
hold off
xlabel('f [Hz]')
ylabel('Power[db]')
legend('立下り','立上り');

% ylim([-350,0])
 xlim([0,24e3])

% saveas(gcf,'.\wav_amp_nonpull\Diff.png')

%% ALL FIGURE
figure(4)
L=length(signal_all);
Y = fft(signal_all);
P2 = abs(Y/L);
P1_s = P2(1:L/2+1);
P1_s(2:end-1) = 2*P1_s(2:end-1);
f_s = Fs*(0:(L/2))/L;
plot(f_s,mag2db(P1_s),'Linewidth',1.3)
title('Normal signal')
xlabel('f [Hz]')
ylabel('Power[db]')

ylim([-350,0])
xlim([0,24e3])

ax=gca;
ax.ColorOrder=BLU
ax.FontSize=10;
% saveas(gcf,'.\wav_amp_nonpull\Before_signal.png')

% %% Time domaine
% figure(5)
% scatter(1:length(signal_pull),signal_pull,15);
% 
% title('Pull signal')
% xlabel('sample')
% ylabel('Amplitude')
% ax=gca;
% ax.ColorOrder=BLU
% ax.FontSize=10;
% 
% figure(6)
% scatter(1:length(signal_push),signal_push,15);
% 
% title('Push signal')
% xlabel('sample')
% ylabel('Amplitude')
% ax=gca;
% ax.ColorOrder=ORG
% ax.FontSize=10;
% 
% 
% figure(7)
% scatter(1:length(signal_all),signal_all);
% 
% title('Normal signal')
% xlabel('sample')
% ylabel('Amplitude')
% ax=gca;
% ax.ColorOrder=GRN
% ax.FontSize=10;
% 
% 
% figure(8)
% plot(signal_pull-signal_all(1:length(signal_pull)),'Linewidth',1.3);
% 
% title('Pull-signal')
% xlabel('sample')
% ylabel('Amplitude')
% ax=gca;
% ax.ColorOrder=BLU
% ax.FontSize=10;
% 
% figure(9)
% plot(signal_push-signal_all(1:length(signal_push)),'Linewidth',1.3);
% 
% title('Push-signal')
% xlabel('sample')
% ylabel('Amplitude')
% ax=gca;
% ax.ColorOrder=ORG
% ax.FontSize=10;
% 
% figure(10)
% plot(signal_pull-signal_push,'Linewidth',1.3);
% 
% title('Pull-Push')
% xlabel('sample')
% ylabel('Amplitude')
% ax=gca;
% ax.ColorOrder=GRN
% ax.FontSize=10;

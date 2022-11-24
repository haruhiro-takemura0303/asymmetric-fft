clear all
close all
run('Example1.m')
run('color.m')

figure(1)
L=length(signal_push);
Y = fft(signal_push);
P2 = abs(Y/L);
P1_s = P2(1:L/2+1);
P1_s(2:end-1) = 2*P1_s(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,mag2db(P1_s),'Linewidth',1.5,'Color',ORG)
% ylim([-90,0]);
xlim([0,25000]);
title('Push')
xlabel('f [Hz]')
ylabel('Power[db]')
% saveas(gcf,'.\image\Cos_Push_48.png')

figure(2)
L=length(signal_pull);
Y = fft(signal_pull);
P2 = abs(Y/L);
P1_l = P2(1:L/2+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,mag2db(P1_l),'Linewidth',1.5,'Color',BLU)
% ylim([-90,0]);
xlim([0,25000]);
title('Pull')
xlabel('f [Hz]')
ylabel('Power[db]')
% saveas(gcf,'.\image\Cos_Pull_48.jpg')

figure(3)
hold on
plot(f,mag2db(P1_s),'Linewidth',2.5,'Color',ORG)
plot(f,mag2db(P1_l),'Linewidth',1.5,'Color',BLU)

% ylim([-90,0]);
xlim([0,25000]);
title('Push・Pull')
legend('Push','Pull')
xlabel('f [Hz]')
% ylabel('Power[db]')
saveas(gcf,'.\image\Cos_Push・pull_48.jpg')
hold off


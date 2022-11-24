run('Example3.m');
run('color.m');

%% figure
figure(1)
L=length(noise_signal(1:end-1));
Y = fft(noise_signal(1:end-1));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,mag2db(P1),'Linewidth',1.3,'Color',GRN)
% ylim([-90,0]);
xlim([0,Fs/2]);
title('all_noise')
xlabel('f [Hz]')
ylabel('Power[db]')
saveas(gcf,['.\image\nois_all_',num2str(Fs),'.png'])


figure(2)
L=length(signal_push);
Y = fft(signal_push);
P2 = abs(Y/L);
P1_s = P2(1:L/2+1);
P1_s(2:end-1) = 2*P1_s(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,mag2db(P1_s),'Linewidth',1.3,'Color',BLU)
% ylim([-90,0]);
xlim([0,Fs/2]);
title('Push_noise')
xlabel('f [Hz]')
ylabel('Power[db]')
saveas(gcf,['.\image\noise_Push_',num2str(Fs),'.png'])


figure(3)
L=length(signal_pull);
Y = fft(signal_pull);
P2 = abs(Y/L);
P1_l = P2(1:L/2+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,mag2db(P1_l),'Linewidth',1.3,'Color',ORG)
% ylim([-90,0]);
xlim([0,Fs/2]);
title('Pull_noise')
xlabel('f [Hz]')
ylabel('Power[db]')
saveas(gcf,['.\image\noise_Pull_',num2str(Fs),'.png'])


figure(4)
hold on
plot(f,mag2db(P1_s),'Linewidth',1.3,'Color',ORG)
plot(f,mag2db(P1_l),'Linewidth',1.3,'Color',BLU)

title('Push・Pull')
legend('Push','Pull')
xlim([0,Fs/2]);
title('noise_resample')
xlabel('f [Hz]')
ylabel('Power[db]')
 saveas(gcf,['.\image\noise_diff_',num2str(Fs),'.png'])

hold off



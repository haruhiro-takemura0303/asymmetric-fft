run('Example4.m');
run('color.m');

%% figure
figure(1)
L=length(signalI(1:end-1));
Y = fft(signalI(1:end-1));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,mag2db(P1),'Linewidth',1.3,'Color',GRN)
% ylim([-90,0]);
xlim([0,FsI/2]);
title('all_resample')
xlabel('f [Hz]')
ylabel('Power[db]')
saveas(gcf,['.\image\Cos_all_',num2str(FsI),'.png'])


figure(2)
L=length(signalI_push);
Y = fft(signalI_push);
P2 = abs(Y/L);
P1_s = P2(1:L/2+1);
P1_s(2:end-1) = 2*P1_s(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,mag2db(P1_s),'Linewidth',1.3,'Color',BLU)
% ylim([-90,0]);
xlim([0,Fs/2]);
title('Push_resample')
xlabel('f [Hz]')
ylabel('Power[db]')
saveas(gcf,['.\image\Cos_Push_',num2str(FsI),'.png'])


figure(3)
L=length(signalI_pull);
Y = fft(signalI_pull);
P2 = abs(Y/L);
P1_l = P2(1:L/2+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,mag2db(P1_l),'Linewidth',1.3,'Color',ORG)
% ylim([-90,0]);
xlim([0,Fs/2]);
title('Push_resample')
xlabel('f [Hz]')
ylabel('Power[db]')
saveas(gcf,['.\image\Cos_Pull_',num2str(FsI),'.png'])


figure(4)
hold on
plot(f,mag2db(P1_s),'Linewidth',1.3,'Color',ORG)
plot(f,mag2db(P1_l),'Linewidth',1.3,'Color',BLU)

title('Push・Pull')
legend('Push','Pull')
xlim([0,Fs/2]);
title('Push_resample')
xlabel('f [Hz]')
ylabel('Power[db]')
saveas(gcf,['.\image\Cos_diff_',num2str(FsI),'.png'])

hold off



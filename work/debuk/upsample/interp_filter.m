run Example4.m

figure(1)
[h,w]=freqz(b);

F=w.*(FsI/(2*pi));
h=abs(h);

signal_up=upsample(signal,Fup);

L=length(signal_up(6:end-4));
Y = fft(signal_up(6:end-4)); 

P2_b = abs(Y/L);
P1_b = P2_b(1:L/2+1);
P1_b(2:end-1) = 2*P1_b(2:end-1);
f_b = FsI*(0:(L/2))/L;



figure(2)
hold on

plot(f_b,mag2db(P1_b),'Linewidth',2.0);
plot(F,mag2db(h),'Linewidth',2.0);
title('F-responce')
xlabel('f [Hz]')
ylabel('Power[db]')

legend('signal','freqz')
xlim([0,FsI/2])

ax=gca;
ax.FontSize=10;
hold off


L=length(signalI(1:end-3));
Y = fft(signalI(1:end-3)); 
P2 = abs(Y/L);
f = FsI*(0:(L))/L;
f=f(1:end-1);

figure(3)
hold on
% plot(F,mag2db(h),'Linewidth',2.0);
semilogx(f,mag2db(P2),'Linewidth',2.0)
title('Pull resample')
xlabel('f [Hz]')
ylabel('Power[db]')
xlim([0,FsI/2])
title('F-responce')
hold off

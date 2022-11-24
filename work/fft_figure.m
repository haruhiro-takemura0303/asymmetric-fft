clear all; close all;
%% run
run distortion_asyn_diffangle.m
run color.m

%% param
signal = signald21;


%% PULL FIGURE
figure(1)

L=length(signal);
Y = fft(signal); 
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

plot(f,mag2db(P1),'Linewidth',2.0)

title('signald21')
xlabel('f [Hz]')
ylabel('Power[db]')

ylim([-350,0])
xlim([0,24e3])

ax=gca;
ax.ColorOrder=GRN
ax.FontSize=10;

saveas(gcf,'C:\Users\竹村　東洋\Box\[M]4321535竹村東洋\研究データ\h.takemura\work\20220714\asyn_nonliner\signald21.jpg')

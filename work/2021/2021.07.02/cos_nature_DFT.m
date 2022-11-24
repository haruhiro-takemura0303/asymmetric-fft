clear all
close all
run('Example2.m')
run('color.m')


% y=signal_pull;
% N = length(y); % 信号の長さ
% % DFTを定義式に従って計算します
% i = (0 : N-1);         % yのデータの個数に対応するiを準備
% k = (0 : N-1)';        % 周波数の個数に対応するkを準備
% expart = exp(complex(0,-(2*pi/N)*k*i)); %　exp(-j*(2*pi/N)*k*i)に対応
% C = 1/N * sum(y.*expart);             % 離散フーリエ変換を実行します
% % DFT後の結果をプロットします
% f = Fs*(0:N-1)/N;
% figure;plot(f,C);grid
% xlabel('frequency(Hz)')
% ylabel('abs(C)')


% figure(1)
% L=length(signal_push);
% Y = signal_push*dftmtx(L);
% P2 = abs(Y/L);
% P1_s = P2(1:L/2+1);
% P1_s(2:end-1) = 2*P1_s(2:end-1);
% f = Fs*(0:(L/2))/L;
% plot(f,mag2db(P1_s),'Linewidth',1.5,'Color',ORG)
% % ylim([-90,0]);
% % xlim([0,25000]);
% title('Push')
% xlabel('f [Hz]')
% ylabel('Power[db]')
% saveas(gcf,'.\image\Push_48.1.png')


figure(1)
plot(t,signal_push);

% figure(2)
% scatter(time(1:signal_pull),signal_pull)
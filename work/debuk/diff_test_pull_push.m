%%%理想波形との差分解析をしてみよう。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%テスト波形ー立上り波形
%%%テスト波形ー立下り波形
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run make_distortion_diffangle
run color.m


%　合成前波形FFT
L=length(signald(1:length(signal)/2));
Y = fft(signald);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);



%% 立上り・立下り分解
[cell_pull,cell_push] = makeinv_time_domaine (signald,signal,Fs,f);

signal_pull = readArray(cell_pull);
signal_push = readArray(cell_push);

% 立上りFFT
L=length(signal_push);
Y = fft(signal_push);
P2 = abs(Y/L);
P1_push = P2(1:L/2+1);
P1_push(2:end-1) = 2*P1_push(2:end-1);

% 立下りFFT
L=length(signal_pull);
Y = fft(signal_pull);
P2 = abs(Y/L);
P1_pull = P2(1:L/2+1);
P1_pull(2:end-1) = 2*P1_pull(2:end-1);

% 歪波形半分に
signald = signald(1:length(signal)/2);
t=1:length(signald)

%% テスト波形ーPUSH

% 時系列確認
signal_diff = signal_push - signald;


figure(3)
hold on
scatter(t,signal_diff);
plot(signal_diff)
hold off
title('Push-test')
xlabel('sample')
ylabel('Amplitude')
ax=gca;
ax.ColorOrder=ORG;
ax.FontSize=10;

% 周波数領域確認

L=length(signal_diff);
Y = fft(signal_diff); 
P2 = abs(Y/L);
P1_diff = P2(1:L/2+1);
P1_diff(2:end-1) = 2*P1_diff(2:end-1);
f = Fs*(0:(L/2))/L;

figure (4)
plot(f,mag2db(P1_diff),'Linewidth',2.0)
title('Push-test')
xlabel('f [Hz]')
ylabel('Power[db]')
ax=gca;
ax.ColorOrder=ORG
ax.FontSize=10;

%% テスト波形ーPULL
% 時系列確認
signal_diff = signal_pull - signald;


figure(5)
hold on
scatter(t,signal_diff);
plot(signal_diff)
hold off
title('Push-test')
xlabel('sample')
ylabel('Amplitude')
ax=gca;
ax.ColorOrder=BLU
ax.FontSize=10;

% 周波数領域確認

L=length(signal_diff);
Y = fft(signal_diff); 
P2 = abs(Y/L);
P1_diff = P2(1:L/2+1);
P1_diff(2:end-1) = 2*P1_diff(2:end-1);
f = Fs*(0:(L/2))/L;

figure (6)
plot(f,mag2db(P1_diff),'Linewidth',2.0)
title('Pull-test')
xlabel('f [Hz]')
ylabel('Power[db]')
ax=gca;
ax.ColorOrder=BLU
ax.FontSize=10;


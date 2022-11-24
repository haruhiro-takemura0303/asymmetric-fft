clear all
%% 振幅確定

% 振幅傾斜
Kd=6; %db/oct　
D2=-70; %二番目の倍音のゲイン
N=10; %倍音の次数

% 周波数設定
f=1000;
Fs=48000*5;

k = 1000*10;       %Signal with 2000 periods
kn = floor((Fs/f)*k +1);  %Create amount of samples
t = (0:kn-1)/Fs;          %Create time samples

i=2; for n=2:1:N
Amp(i)=10^((D2-Kd*log2(n/2))/20);

i=i+1;
end

Amp(1)=1;

%% 合成
w=zeros(1,10);
w(1,1)=0;
w(1,2:10)=rand(1,9);

y=0; i=1; 
for i=1:N
 
 yn(i,:)=Amp(i)*cos(2*pi*f*i*t+w(i)*pi);
 y=yn(i,:)+y;
 
end


signald=y;
signal=yn(1,:);


cell_push=NoiseSeparateMotion(Fs,signal,signald,1,f);
cell_pull=NoiseSeparateMotion(Fs,signal,signald,2,f);


signal_pull = readArray(pullInversion(cell_pull));
signal_push = readArray(pullInversion(cell_push));
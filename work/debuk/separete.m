clear all
close all
Fs=48e3;
T=0.1;
F=500;

t=0:1/Fs:T;
k=500;
data=load('data/2021.10.01/cos_500.mat');
[signal,time,amp] = reshapedata(data,Fs,F,k);
signal=signal';



% reshape data
frame=3;
start=1;
yy=signal(start:start+Fs/F*frame);

% make gaide
kk=10;
Amp=mean(findpeaks(yy));
[gaid,tt] = createCos(F,Fs,Amp,kk);



figure(1)
hold on
plot(gaid)
plot(yy)
legend('gaid','siganl')
hold off

xlabel('sample')
ylabel('Amplitude')
gaid;

%% 波形の位置合わせ（相互相関）
[C21,lag21] = xcorr(gaid,yy);
C21 = C21/max(C21);

[M21,I21] = max(C21);
t21 = lag21(I21);

figure(2)
plot(lag21,C21,[t21 t21],[-0.5 1],'r:')
text(t21+100,0.5,['Lag: ' int2str(t21)])
ylabel('C_{21}')
axis tight
title('Cross-Correlations')

gaid = gaid(t21+1:end);
figure(3)
hold on
plot(gaid)
plot(yy)
xlabel('sample')
ylabel('Amplitude')
legend('gaid','siganl')
hold off

%% 配列整理
[push_signal,push_gaid] = NoiseSeparateMotion(Fs,yy,gaid(1:Fs/F*3),1);
[pull_signal,pull_gaid] = NoiseSeparateMotion(Fs,yy,gaid(1:Fs/F*3),2);


signal_push = cell(1,k);
signal_pull = cell(1,k);

pushL=length(push_signal);
pullL=length(pull_signal);

signal_push{1,1}=push_signal{1,pushL-1};
signal_pull{1,1}=pull_signal{1,pullL-1};

A=0;
for i=0:1:1
An=length(push_signal{1,pushL-i})+length(pull_signal{1,pullL-i});
A=A+An;
end
start=start+(length(yy)-A);


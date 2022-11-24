clc
clear all
close all

%Normalize a signal using interpolation an analyze it with signal
%reconstruction
F = 5000;
Fs = 48e3;
FsI =5*48e3;
Fup=lcm(Fs,FsI)/Fs;
Fdun=lcm(Fs,FsI)/FsI;
amp = 1;
k = 5000;

%% make low pass filter
N   = 300;
Fp  = Fs*0.4;
Ap  = 0.01;
Ast = 160;

Rp  = (10^(Ap/20) - 1)/(10^(Ap/20) + 1);
Rst = 10^(-Ast/20);

NUM = firceqrip(N,Fp/(FsI/2),[Rp Rst],'passedge');
% fvtool(NUM,'Fs',Fs)
delay = mean(grpdelay(NUM))

%% Create time, signal and interpolated time samples
k_real=k+2+ceil(delay/(FsI/F));
[signal,t] = createCos(F,Fs,amp,k_real);% "k+2" remove two interval in Reshape section

%% RESAMPLEING

% up sampling
signal_up=upsample(signal,Fup);
y=filter(NUM,1,signal_up);

% reshape
ys=5*y(delay:end);
yy=ys(194:48002); 

figure(1)
plot(signal_up);
xlabel('sample')
ylabel('Amplitude')
title('uppsamplor')

figure(2)
plot(y);
xlabel('sample')
ylabel('Amplitude')
title('filter in ')

figure(3)
hold on
plot(4*y(delay:end))
hold off
xlabel('sample')
ylabel('Amplitude')

figure(4)
plot(4*yy)
xlabel('sample')
ylabel('Amplitude')
title('reshape upsampling')
hold off

figure(5)
L=length(4*yy(1:end-1));
Y = fft(4*yy(1:end-1)); 
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = FsI*(0:(L/2))/L;
plot(f,mag2db(P1),'Linewidth',2.0)
title('upsample - Lowpass')
xlabel('f [Hz]')
ylabel('Power[db]')

%% reshape data
% [signal,t] = createCos(F,FsI,amp,k+2);
% noise=yy; 
% [signalI_push] = NoiseSeparateMotion(Fs,signal,noise,1,f);
% [signalI_pull] = NoiseSeparateMotion(Fs,signal,noise,2,f);
% 
% signalI_push = readArray(pushInversion(signalI_push(2:end-1))); % remove First and Last push interval
% signalI_pull = readArray(pullInversion(signalI_pull(2:end-1))); % remove First and Last pullinterval


%% pull-push separate
%Reconstruct Push-signal
signal_push = cosReconstruct(yy,FsI,1);
%Reconstruct Pull-singal
signal_pull = cosReconstruct(yy,FsI,2);


L=length(signal_push);
Y = fft(signal_push); 
P2 = abs(Y/L);
P1_s = P2(1:L/2+1);
P1_s(2:end-1) = 2*P1_s(2:end-1);
f_s = FsI*(0:(L/2))/L;

L=length(signal_pull);
Y = fft(signal_pull); 
P2 = abs(Y/L);
P1_l = P2(1:L/2+1);
P1_l(2:end-1) = 2*P1_l(2:end-1);
f_l = FsI*(0:(L/2))/L;

figure(6)
hold on
plot(f_s,mag2db(P1_s),'Linewidth',2.0)
plot(f_l,mag2db(P1_l),'Linewidth',2.0)
hold off
title('upsampling-Lowpass')
xlabel('f [Hz]')
ylabel('Power[db]')
legend('Push','Pull')
ylim([-400,50])
ax=gca;
ax.FontSize=10;
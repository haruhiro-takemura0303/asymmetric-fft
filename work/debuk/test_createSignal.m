clear all

% param
Fs = 48e3;
f = 1e3;
amp = 1;

% Instance
test = CreateSignal(Fs,f,amp);
plt = Visual(Fs,f)

% execute
[signal,time] = test.createSinSample(100);
dist_signal = test.createDistorionSignal(-10,-50,10,signal);

% visual
% figure(1)
% plt.plotFFT(signal(1:end-1),"ORIGIN");

figure(2)
plt.plotFFT(dist_signal(1:end-1),"ORIGIN",Fs/2);


k = fix(length(signal)/(Fs/f))
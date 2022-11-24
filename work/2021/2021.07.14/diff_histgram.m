clear all
close all
data=load('cos_1000_48_1.mat');
timed=data.Scope{4,1};
signald=data.Scope{4,2};


[pks,locs] = findpeaks(signald);

start=locs(1);

signal=signald(start:start+192*100)';
time=timed(start:start+192*100)';


data_diff=diff(signal);
% 
nbins = 101;


f = 1000;       %Frequency of 1 kHz
Fs = 192000;     %Frequency of 48 kHz;
k = 100;       %Amount of periods: 2000
amp = 15.9;      %Amplitude of 2.5

signalg = createCos(f,Fs,amp,k);

datag_diff=diff(signalg);

figure(1)
hold on
h = histogram(data_diff,nbins);
% h2=histogram(datag_diff,nbins);
hold off

under= h.Values(1:(nbins-1)/2)
upper=h.Values((nbins+1)/2+1:end)

figure(2)
hold on
td=1:length(under);
tu=length(upper):-1:1
plot(td,under);
plot(tu,upper);
hold off
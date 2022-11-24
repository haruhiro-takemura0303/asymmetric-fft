clcsignal
clear all 
close all

%Swap nonlinear components and linear components of a signal and use signal
%reconstruction to analyze the frequency spectra
%Linear Push; Nonlinear Pull

%Load nonlinear sine wave; f = 1000; Fs = 48000; amp = sqrt(2);
load('sin1k_1amp_48_kHz.mat')

%Assign data from audio analyzer
time = Scope{4,1}';
scope = Scope{4,2}(1:12000)';

%Create linear signal
Fs = 48000;
f = 1000;
amp = 1.408240943130305;
k = 250; 
[y,t] = createSineSample(f,Fs,amp,length(scope));

%Divide into nonlinear and linear components
[nonlinear_push,linear_push] = NoiseSeparateMotion(Fs,y,scope,1);
[nonlinear_pull, linear_pull] = NoiseSeparateMotion(Fs,y,scope,2);

%Keep the nonlinear Pull-components; Swap the nonlinear push-components to
%linear ones
semi_linear_signal = readArray(nonlinearSwap(linear_push,nonlinear_pull,1));

%Figure 
figure(1); hold on;
plot(t,semi_linear_signal,'-b','Linewidth',1.5)
plot(t,y,'-k','Linewidth',1.5)
xlim([0,0.0005]);
xlabel('Time t in [s]');ylabel('Amplitude');
title('nonlinear/linear mixed Sine-Wave');
legend('nonlinear','linear');
hold off;

%Divide into push and pull signal
signal_push = noisySineReconstruct(semi_linear_signal,y,Fs,1);
signal_pull = noisySineReconstruct(semi_linear_signal,y,Fs,2);
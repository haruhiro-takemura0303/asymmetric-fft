clc
clear all
close all

%Analyze nonlinear data with samples from the audio analyzer
%Load data
load('sin1k_1amp_48_kHz');

%Load Scope and time
time = Scope{4,1}';
scope = Scope{4,2}';

%Create guide signal with same characteristics
Fs = 48000;
f = 1000;
amp = 1.408240943130305;
guide_signal = createSineSample(f,Fs,amp,length(scope));

%Reconstruct
signal_push = noisySineReconstruct(scope,guide_signal,Fs,1);
signal_pull = noisySineReconstruct(scope,guide_signal,Fs,2);


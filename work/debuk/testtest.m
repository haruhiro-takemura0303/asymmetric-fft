close;
clear all;

Fs = 48e3;
T = 1/Fs;
time_length = 1;
L = Fs*time_length;


t = linspace(0,time_length,Fs*time_length);

Y = 0.88 .* cos(2*pi*1000*t);
Y = Y(1:end-1);

Y_16_2 = int16(Y * 32768);
Y_16 = double(Y_16_2) ./ 32768 ;

fft_Y = fft(Y);
P2 = abs(fft_Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

P1_dB = 20 * log10(P1);
P1_dB = P1_dB - max(P1_dB);

fft_Y_16 = fft(Y_16);
P2_16 = abs(fft_Y_16/L);
P1_16 = P2_16(1:L/2+1);
P1_16(2:end-1) = 2*P1_16(2:end-1);

P1_dB_16 = 20 * log10(P1_16);
P1_dB_16 = P1_dB_16 - max(P1_dB_16);

f = Fs*(0:(L/2))/L;
hold on
plot(f,P1_dB) 
plot(f,P1_dB_16)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('P1 [dB]')
hold off



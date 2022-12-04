clear all
%% visual class のテスト
Fs = 48e3
f = 1000
t = 0:1/Fs:10/f

y = cos(2*pi*f*t)
y = y(1:end-1)

%Instance
p = Visual(Fs,f)

% figure(1)
% p.plotFFT(y,"PULL",Fs/2)
% 
% figure(2)
% p.plotFFT(y,"PUSH",Fs/2)

% figure(3)
p.plotFFT3(y,y,y,Fs/2)


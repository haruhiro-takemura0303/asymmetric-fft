
clear all
% 振幅傾斜
kd=6; %db/oct　
D2e=-60; %二番目の倍音のゲイン
D2o=-80;
N=10; %倍音の次数

% 周波数設定
f  = 1000;
Fs = 48000;
k  = 8;

kn = floor((Fs/f)*k +1); %Create amount of samples
t = (0:kn-1)/Fs;         %Create time samples

%%setting amplitude of harmonic distortion
i=2;

% AMP:Even
for n=1:N/2

Amp(2*n)=10^((D2e-kd*log2(2*n/2))/20);
i=i+1;

end

% AMP:ODD
for n=1:N/2

Amp(2*n+1)=10^((D2o-kd*log2((2*n+1)/2))/20);
i=i+1;

end

Amp(1)=1;

%%Synthesis

% setting angle
w=zeros(1,10);
w(1,1)=0;
w(1,2:10)=rand(1,9); %% angle=w*pi

% syntesis
y=0; i=1; 
for i=1:N
 
 yn(i,:)=Amp(i)*cos(2*pi*f*i*t+w(i)*pi);
 y=yn(i,:)+y;
 
end

signald=y;       % distorted sample
signal=yn(1,:);  % base samle

function makedata(Fs,Kc,F)

% Kc:最低の繰り返し周期
% 測定データの作成
% データ長を固定するため、波形の個数はKc×10

Amp=1; %振幅
K=Kc*F;
T=(1/F)*K*2;
t=0:1/Fs:T;

signal(1:Fs)=0;
signal(Fs+1:Fs+length(t))=Amp*sin(2*pi*F*t);

end
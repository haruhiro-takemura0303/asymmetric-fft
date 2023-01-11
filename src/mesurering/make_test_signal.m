
%-------------------------config-----------------------------------------
fs = 48e3;
f = 1e3;
period = 1;
path = "./data/testsound";

%-------------------------main------------------------------------------
signal = makeData(fs,f,period,path);

figure(1)
plot(signal);
title("Test Sound")

function signal = makeData(fs,period,f, path)
    % Kc:最低の繰り返し周期
    % 測定データの作成
    % データ長を固定するため、波形の個数はKc×10
    
    Amp=1; %振幅
    k=period*f;
    T=(1/f)*k*2;
    t=0:1/fs:T;
    
    signal(1:fs)=0;
    signal(fs+1:fs+length(t))=Amp*sin(2*pi*f*t);
    
    name = path+"/"+num2str(f)+"_sin.wav";
    audiowrite(name,signal,fs,'BitsPerSample',16);
    
end
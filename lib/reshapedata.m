function [signal,time,amp] = reshapedata(data,samplingFreq,Frequency,countCycle)
% 取得データを成形
% 指定された周期分だけ切り出し

Fs=samplingFreq;
F=Frequency;
k=countCycle;

timed=data.Scope{4,1};
signald=data.Scope{4,2};

% detection start point
[pks,locs] = findpeaks(signald);
ampth=mean (pks)*0.8;
n=1;
for i=1:length(pks)
if pks(i)>ampth %クソ雑魚ピークもカウントしちゃうから、ampth以下のピークはさよなら
    start(1,n)=pks(i);
    start(2,n)=locs(i);
    n=n+1;
end
end

amp=mean ( start(1,:) );
signal=signald(start(2,5) : start(2,5) + (Fs/F)*k);
time=0:1/Fs:k/F;
end
function [signal_push,signal_pull] = dataSepatateMotion(Fs,signal,F,k)

% signal=signal';
signal_push = cell(1,k);
signal_pull = cell(1,k);

start=1; i=1;
for count=1:k-2;
%% 波形＋ガイドの準備
% reshape data
frame=3;
yy=signal(start:start+Fs/F*frame);

% make gaide
kk=10;
Amp=mean(findpeaks(yy));
[gaid,tt] = createCos(F,Fs,Amp,kk);


%% 波形の位置合わせ（相互相関）
[C21,lag21] = xcorr(gaid,yy);
C21 = C21/max(C21);

% calculate lags
[M21,I21] = max(C21);
t21 = lag21(I21);

gaid = gaid(t21+1:end);

%% 配列整理
[push_gaid,push_signal] = NoiseSeparateMotion(Fs,yy,gaid(1:Fs/F*3),1);
[pull_gaid,pull_signal] = NoiseSeparateMotion(Fs,yy,gaid(1:Fs/F*3),2);

pushL=length(push_signal);
pullL=length(pull_signal);

% one period pull・push signal in Cross-correlation situation

    if count == 1;
        signal_push{1,i}=push_signal{1,pushL-2};
        signal_pull{1,i}=pull_signal{1,pullL-2};

        signal_push{1,i+1}=push_signal{1,pushL-1};
        signal_pull{1,i+1}=pull_signal{1,pullL-1};
        
        i=i+2;
    elseif count == k-2;
        
        signal_push{1,i}=push_signal{1,pushL-1};
        signal_pull{1,i}=pull_signal{1,pullL-1};

        signal_push{1,i+1}=push_signal{1,pushL};
        signal_pull{1,i+1}=pull_signal{1,pullL};        
        
        i=i+2;
    else
        signal_push{1,i}=push_signal{1,pushL-1};
        signal_pull{1,i}=pull_signal{1,pullL-1};
        
        i=i+1;
    end
        

% calculate next start point
A=length(push_gaid{1,1})+length(pull_gaid{1,1});
start=start+A;
% AA(count)=start;
% AAmp(count)=Amp;
% BB(count)=start+length(pull_gaid{1,1});
end
% signal_push = readArray(pushInversion(signal_push));
% signal_pull = readArray(pullInversion(signal_pull));
end




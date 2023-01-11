clear all
polarNum = 1;
freqNum = 1;
vppNum =1;
trialNum = 1;
mode = 1;

%% config
AMP_TYPE = "a"; %a,b,c 
SUPPLY_TYPE = "clean"; %clean,com, uni
DATA_PATH  = "./data/processed/";

% 分析情報
period = 10;
up_rate = 5;
rate_trim = 0.05;
DIRECTION = "x";

% 電源極性
polar_list1  = ["aa" "ab" "ba" "bb"]; %cl,co 
polar_list2  = ["c" "d"]; %uni

if SUPPLY_TYPE == "uni"
    polar_list = polar_list2;
else
    polar_list = polar_list1;
end

%% データセットの読み込み

%読み込み
data_strct = load(DATA_PATH +"amp_"+AMP_TYPE+"/"+SUPPLY_TYPE+".mat");
load(DATA_PATH +"amp_"+AMP_TYPE+"/parameter.mat");

%% 信号の読み込み
data = data_strct.(SUPPLY_TYPE).(polar_list(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).signal;

%信号の情報
fs = parameter.Fs;
fs_up = up_rate*fs;
f = parameter.freq(freqNum);
vpp = parameter.vpp(vppNum);

%% main

% インスタンス化
rec = Reconstruct(period);

%６回計測の内一つを抜き出す
for signalNum = 1:6
    signal = data(:,signalNum);
    
    % 前処理
    [signal_p,fs_p] = executePreprocess(signal,fs,f,fs_up,rate_trim);
    
    % 分離
    sep = Separation(fs_p,f);
    cellSignal = sep.separateExtendMotion(signal_p,mode);
    
    % 合成
    if DIRECTION == "y"
        signalPush = rec.reconstructVertical(cellSignal,mode);
        signalPull = rec.reconstructVertical(cellSignal,mode);
    
    elseif DIRECTION == "x" 
        signalPush = rec.reconstructHorizontal(cellSignal,mode);
        signalPull = rec.reconstructHorizontal(cellSignal,mode);
    end
    
    pushlist(:,signalNum) = signalPush;
    pulllist(:,signalNum) = signalPull;
    
%     % fft
%     dataFFT = doFFT(signal,fs)
%     
end




%% function
function [signal_p,newfsp] = executePreprocess(signalp,fsp,f,fsp_up,rate_trim)
    % コンストラクタ
    pre = Preprocess(fsp,f);

    % 無音処理
    signal_p1 = pre.trimSilence(signalp);
    
    % アップサンプリング
    if fsp_up ~=0
        signal_p2 = pre.resampleSignal(fsp_up,signal_p1);
        newfsp = fsp_up;
        pre = pre.resetFs(newfsp); % サンプリング周波数の再定義
    
    else
        signal_p2 = signal_p1;
        newfsp = fsp;
    end
    
    % 前後切り出し
    trim_period = round(length(signal_p2)*rate_trim / (newfsp/f));
    signal_p = pre.reshapeSignal(trim_period,signal_p2);
end


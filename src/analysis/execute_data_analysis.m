clear all
clear classes


%----------------------------------config------------------------------------
% データタイプ
AMP_TYPE = "a"; %a,b,c 
DATA_PATH  = "./data/processed";
SAVE_PATH = "./data/analysis";
DIRECTION = "Vertical"; %Vertical , Horizontal

% 分析周期
PERIOD_LIST = [5*40,5*1000,5*10000];

% アップサンプリング倍率
UPRATE_LIST = [0,10,20];

%--------------------------------------info------------------------------------
% 電源タイプ
SUPPLY_LIST = ["clean" "commercial" "uni"];

% 電源極性
polarList1  = ["aa" "ab" "ba" "bb"]; %cl,co 
polarList2  = ["c" "d"]; %uni

% 試行回数
trialLen = 2;

% amp
AMP_NAME = "amp_" + AMP_TYPE;

% 切り取り
rate_trim = 0.05;

% 信号情報
load(DATA_PATH+"/"+AMP_NAME+"/parameter.mat");

%--------------------------------------main------------------------------------
for supplyNum = 1:length(SUPPLY_LIST)
    %%データセットの読み込み
    % 読み込み
    supplyType = SUPPLY_LIST(supplyNum);
    disp("----Start Analysis "+AMP_NAME+" "+supplyType+"----")
    disp("% Read Data")
    data_strct = load(DATA_PATH+"/"+AMP_NAME+"/"+supplyType+".mat");
    
    if supplyType == "uni"
        polarList = polarList2;
    else
        polarList = polarList1;
    end
    
    for polarNum = 1:length(polarList)
        for freqNum = 1:length(length(parameter.freq))
            for vppNum = 1:length(parameter.vpp)
                for trialNum = 1:trialLen
    
                    %%信号の読み込み
                    disp(" ")
                    disp("---Read Signal---")
                    data = data_strct.(supplyType).(polarList(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).signal;
                    
                    % 信号の情報
                    fs = parameter.Fs;
                    fs_up = UPRATE_LIST(freqNum)*fs;
                    f = parameter.freq(freqNum);
                    disp("   - Polar : "+polarList(polarNum))
                    disp("   - Fs    : "+num2str(fs))
                    disp("   - Fs_up : "+num2str(fs_up))
                    disp("   - Freq  : "+num2str(f))
                    disp("   - Vpp   : "+num2str(parameter.vpp(vppNum)))
                    disp("   - Trial : "+num2str(trialNum))

                    %---------------------analysis----------------------------
                    disp("% Start fft analysis")
                    % インスタンス
                    rec = Reconstruct(PERIOD_LIST(freqNum));
                    
                    % 信号の分析
                    for signalNum = 1:6
                        disp("   - Calculate Signal "+ num2str(signalNum))
                        signal = data(:,signalNum);
                        
                        % 前処理
                        [signal_p,fs_p] = executePreprocess(signal,fs,f,fs_up,rate_trim);
                        
                        % 分離
                        sep = Separation(fs_p,f);
                        cellPushSignal = sep.separateExtendMotion(signal_p,1);
                        cellPullSignal = sep.separateExtendMotion(signal_p,2);
                        
                        % 合成
                        if DIRECTION == "Vertical"
                            signalPush = rec.reconstructVertical(cellPushSignal,1);
                            signalPull = rec.reconstructVertical(cellPullSignal,2);
                        
                        elseif DIRECTION == "Horizontal" 
                            signalPush = rec.reconstructHorizontal(cellPushSignal,1);
                            signalPull = rec.reconstructHorizontal(cellPullSignal,2);
                        end
                        
                        % fft
                        [~,signalFFTlist(:,signalNum)] = calcFFT(fs_p,signal_p(1:length(signalPush)+length(signalPull)));
                        [~,pushFFTlist(:,signalNum)] = calcFFT(fs_p,signalPush);
                        [~,pullFFTlist(:,signalNum)] = calcFFT(fs_p,signalPull);
                        
                    end
                    
                    %データの格納
                    if supplyType == "clean"
                        clean.(polarList(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).mode(1).magnitude = pushFFTlist;
                        clean.(polarList(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).mode(2).magnitude = pullFFTlist;
                        clean.(polarList(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).mode(3).magnitude = signalFFTlist;
                    
                    elseif supplyType == "commercial"
                        commercial.(polarList(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).mode(1).magnitude = pushFFTlist;
                        commercial.(polarList(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).mode(2).magnitude = pullFFTlist;
                        commercial.(polarList(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).mode(3).magnitude = signalFFTlist;
                    
                    elseif supplyType == "uni"
                        uni.(polarList(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).mode(1).magnitude = pushFFTlist;
                        uni.(polarList(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).mode(2).magnitude = pullFFTlist;
                        uni.(polarList(polarNum)).freq(freqNum).vpp(vppNum).trial(trialNum).mode(3).magnitude = signalFFTlist;
                    end
                    disp("% Finish FFT Analysis\n")
                end
            end
        end
    end
end

% parameterへ追記
parameter.period = PERIOD_LIST;
parameter.upRate = UPRATE_LIST;

%--------------------------------------save------------------------------------
disp("% Save Analysis Data")
disp("   - Amp       : "+AMP_NAME)
disp("   - Direction : "+DIRECTION)

%フォルダの確認
if exist(SAVE_PATH+"/"+AMP_NAME,"dir") == 0
    mkdir(SAVE_PATH+"/"+AMP_NAME)
    mkdir(SAVE_PATH+"/"+AMP_NAME+"/Vertical")
    mkdir(SAVE_PATH+"/"+AMP_NAME+"/Horizontal")
end

% 保存
save(SAVE_PATH+"/"+AMP_NAME+"/"+DIRECTION+"/clean.mat","clean",'-v7.3');
save(SAVE_PATH+"/"+AMP_NAME+"/"+DIRECTION+"/commercial.mat","commercial",'-v7.3');
save(SAVE_PATH+"/"+AMP_NAME+"/"+DIRECTION+"/uni.mat","uni",'-v7.3');
save(SAVE_PATH+"/"+AMP_NAME+"/"+DIRECTION+"/parameter.mat","parameter",'-v7.3');
disp("% Finish")

%% function
function [signal_p,newfsp] = executePreprocess(signalp,fs,f,fsp_up,rate_trim)
    % コンストラクタ
    pre = Preprocess(fs,f);

    % 無音処理
    signal_p1 = pre.trimSilence(signalp);
    
    % アップサンプリング
    if fsp_up ~=0
        signal_p2 = pre.resampleSignal(fsp_up,signal_p1);
        newfsp = fsp_up;
        pre = pre.resetFs(newfsp); % サンプリング周波数の再定義
    
    else
        signal_p2 = signal_p1;
        newfsp = fs;
    end
    
    % 前後切り出し
    trim_period = round(length(signal_p2)*rate_trim / (newfsp/f));
    signal_p = pre.reshapeSignal(trim_period,signal_p2);
end

function [freq,mag] = calcFFT(fs,signal)
    % FFT実行
    L = length(signal);
    Y = fft(signal); 
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    freq = fs*(0:(L/2))/L;
    mag = mag2db(P1);
end
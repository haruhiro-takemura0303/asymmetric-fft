classdef Separation
    % 信号を立上り・立下りに分割
    properties
    fs      %サンプリング周波数
    f       %分析信号(単一余弦波)の周波数
    end
    
    methods
        %% コンストラクタ
        function param = Separation(sampleRate,freq)
            if nargin == 2
                param.fs = sampleRate;
                param.f = freq;
            else
                error("Input argument need two.")
            end
        end
    
        %% 立上り・立下りの判別
        function check = findModeSample(param,signal,n)
        % 信号の立上り・立下りを判別するヘルパー関数
        %
        %Args: 
        %    signal  : テスト信号
        %    n       : モードの選択 push (1) / pull (2)
        %
        %Return:
        %    check   : 信号内の選択したモードのサンプル番号を1で返す。
        %
        %Note:
        %    視点されたモードの開始点から終了点までを指定する。
        %    振幅がampの余弦波であれば、amp-ampが指定される。
        %
        %====================================================================================  
            %差分を求める
            diffSignal = diff(signal); %前方から
            diffInvSignal = flip(diff(flip(signal))); %後方から
            
            % check配列の宣言
            check = zeros(1,length(signal));
            
            switch n

                % Push の抽出
                case 1
                    checkForw = diffSignal > (0 + 10000*eps);
                    checkInv = diffInvSignal < (0 + 10000*eps);
                
                % Pull の抽出
                case 2
                    checkForw = diffSignal < (0 + 10000*eps);
                    checkInv = diffInvSignal > (0 + 10000*eps);

                otherwise
                    disp('Please enter "1" for a PUSH  or "2" for a PULL');
            end
            
            %配列に格納
            check(1)       = checkForw(1);
            check(2:end-1) = checkForw(2:end) | checkInv(1:end-1);
            check(end) = checkInv(end);
        
        end


        %% 立上り・立下りの開始点の抽出
        function [newTime,newSignal] = extractMotion(param,signal,n)
        % 時系列信号から各モード(立上り・立下り)をサンプルの傾きから抽出するヘルパー関数
        %
        %Args:  
        %    Fs      : サンプリング周波数
        %    signal  : テスト信号
        %    n       : モードの選択 push (1) / pull (2)
        %
        %Return:
        %    new_time: 選択したモードのみからなる時間配列
        %    new_signal: 選択したモードのみからなる振幅配列
        %
        %Note:
        %    ここでは、各モードのデータが一つなぎの時系列データとなって出力される。
        %    ノイズや時間軸方向の歪を考慮していない。
        %
        %====================================================================================  
        
            % 時間配列の宣言
            time = (0:length(signal)-1)/param.fs;
            
            % 指定したモードを抽出
            newTime = time(findModeSample(param,signal,n) == 1);
            newSignal = signal(findModeSample(param,signal,n) == 1);

        end
        
        %%  立上り・立下りの開始点の抽出[ノイズあり]
        function [newGaidTime,newGaidSignal,newNoiseSignal] = extractNoiseMotion(param,signal,gaid,n)
            % ノイズを含んだ時系列信号から各モードをサンプルの傾きから抽出するヘルパー関数
            %
            %Args:  
            %    signal        : ノイズを含んだテスト信号
            %    gaid          : ガイド波形となるノイズを含まない信号
            %    n       : モードの選択 push (1) / pull (2)
            %
            %Return:
            %    new_time        : 選択したモードのみからなる時間配列
            %    new_signal      : 選択したモードのみからなる振幅配列
            %    new_noise_signal: 選択したモードのみからなるノイズ信号の振幅配列 
            %
            %Note:
            %    ここでは、各モードのデータが一つなぎの時系列データとなって出力される。
            %    ホワイトノイズ等のランダム性のノイズを考慮している。
            %    ノイズを含んだ信号と同様の周波数を持つ理想的なガイド信号を作成し、ガイド信号の
            %    立上り・立下りに合わせて、各モードを抽出する。
            %
            %====================================================================================  
            
            % 時間配列の宣言
            time = (0:length(gaid)-1) / param.fs;
            
            % 指定したモードを抽出
            newGaidTime = time(findModeSample(param,gaid,n) == 1);
            newGaidSignal = gaid(findModeSample(param,gaid,n) == 1);
            newNoiseSignal = signal(findModeSample(param,gaid,n) == 1);
            
            end

        %% cellに格納[extractMotion]
        function cellSignal = separateMotion(param,signal,n)
            % extractMotionで抽出した1つなぎのデータをcellごとに格納
            %
            % Args:
            %      extractMotion
            %    　t_motion   (array) : 各モードの時間配列
            %    　sig_motion (array) : 各モードの振幅配列  
            % 
            % Return:
            %    cellSignal (cell)  : 各モードが半周期ごとに格納されたデータ格子
            %
            %====================================================================================    
            % extractMotionの実行
            [timeMotion,signalMotion] = extractMotion(param,signal,n);

            % 半周期ごとの開始点と終了点の特定
            timeStartEnd = 1;
            for k = 1 : length(timeMotion)-1
                
                if(timeMotion(k+1) - timeMotion(k) > 1/param.fs + 70*eps)
                    timeStartEnd = [timeStartEnd,k,k+1];
                end
            
            end
            timeStartEnd = [timeStartEnd, length(timeMotion)];
            
            % 開始点と終了点のデータを使ってセルに格納
            cellSignal = cell(1,length(timeStartEnd)/2);
            for l = 1:size(cellSignal,2)
                cellSignal(1,l) = {signalMotion(timeStartEnd(2*l-1):timeStartEnd(2*l))};
            end
            
            if(nargin == 4)
                
                if(param.n == 1 && mod(param.fs/param.f,4) == 2)
                    for i = 1:size(cellSignal,2)-1
                        cellSignal{1,i} = [cellSignal{1,i},cellSignal{1,i}(end)];
                    end
                end
                
                if(param.n == 2 && mod(param.fs/param.f,4) == 2)
                    for i = 1:size(cellSignal,2)
                        cellSignal{1,i} = [cellSignal{1,i},cellSignal{1,i}(end)];
                    end
                end
            end
        end
        
        %% cellに格納[extractMotion]
        function [cellNoiseSignal,cellSignal] = separateNoiseMotion(param,signal,gaid,n)
           % extractNoiseMotionで抽出した1つなぎのデータをcellごとに格納
           %
           % Args:
           %    extractNoiseMotion
           %     t_motion       (array) : 各モードの時間配列
           %     sig_motion     (array) : ガイド信号の各モードの振幅配列
           %     noise_motion   (array) : ノイズ信号の各モードの振幅配列
           %  
           %  Return:
           %     cellSignal      (cell) : ガイド信号の各モードが半周期ごとに格納されたデータ格子
           %     cellNoiseSignal (cell) : ノイズ信号の各モードが半周期ごとに格納されたデータ格子
           %
           %%====================================================================================   

            %   Detailed explanation goes here
            timeStartEnd = 1;

            % extractNoiseMotionの実行
            [timeMotion,signalMotion,noiseSignalMotion] = extractNoiseMotion(param,signal,gaid,n);
            
            for k = 1 : length(timeMotion)-1
                if(timeMotion(k+1) - timeMotion(k) > 1/param.fs + 7*eps)
                    timeStartEnd = [timeStartEnd,k,k+1];
                end
            end
            
            timeStartEnd = [timeStartEnd, length(timeMotion)];
            cellSignal = cell(1,length(timeStartEnd)/2);
            cellNoiseSignal = cell(1,length(timeStartEnd)/2);
            
            for l = 1:size(cellSignal,2)
                cellSignal(1,l) = {signalMotion(timeStartEnd(2*l-1):timeStartEnd(2*l))};
                cellNoiseSignal(1,l) = {noiseSignalMotion(timeStartEnd(2*l-1):timeStartEnd(2*l))};
            end
        end
        
        %% 時間軸方向に歪んだ波形の切り出し[Separate+Extract]
        function cellExtendSignal = separateExtendMotion(param,signal,n)
            % 時間軸方向に歪んだ波形の切り出し
            %
            % Args:  
            %    signal        : 時間軸方向に歪んだテスト信号
            %
            %Return:
            %    cellExtendSignal    : 各モードが半周期ごとに格納されたデータ格子
            %
            % Note:
            % 実際の音響信号は、ジッタや、クロックのズレによって時間軸方向に非定常な伸縮が生じる（時間軸の歪）
            % ガイド波形をスライドさせながら相互相関を用いることで、ロバストな切り出し位置決定を行う
            %
            %%==================================================================================== 
            
            %%cellの宣言
            margin = 1;
            signalCycleNumber = round(length(signal)/(param.fs/param.f))-margin;
            cellExtendSignal = cell(1,signalCycleNumber);
            
            %%ガイド波形のパラメータ
            gen = CreateSignal(param.fs,param.f,1); %コンストラクタ
            FRAME=3;
            gaidCycleNumber = 4*FRAME; %ガイド波形の周期

            %%波形＋ガイドの準備
            start=1; i=1;

            for count=1:signalCycleNumber-(FRAME-1)
                % Frame 分波形を切り出す
                y = signal(start:start+(param.fs/param.f)*FRAME);

                % ガイド波形の作成
                Amp = max(y);
                gaid = gen.createCosSample(gaidCycleNumber);
                gaid = Amp * gaid; %定数倍しても相関は変わらない,plot確認のため
                
                %%波形の位置合わせ（相互相関）
                [C,lag] = xcorr(gaid,y);
                C = C/max(C);
                
                % calculate lags
                [~,I] = max(C);
                gaid = gaid(lag(I)+1:end);
                
                %% 配列整理
                [extractedSignal,extractedGaid] = separateNoiseMotion(param,y,gaid(1:param.fs/param.f*FRAME+1),n);

                if n == 1
                    [~,extractOtherSignal] = separateNoiseMotion(param,y,gaid(1:param.fs/param.f*FRAME+1),2);
                elseif n == 2
                    [~,extractOtherSignal] = separateNoiseMotion(param,y,gaid(1:param.fs/param.f*FRAME+1),1);
                end
                
                extractLength=length(extractedSignal);
                
                % one period pull・push signal in Cross-correlation situation
                
                    if count == 1
                        cellExtendSignal{1,i} = extractedSignal{1,extractLength-2};
                        cellExtendSignal{1,i+1} = extractedSignal{1,extractLength-1};
                        
                        i=i+(FRAME-1);
                    
                    elseif count == signalCycleNumber-(FRAME-1)
                        
                        cellExtendSignal{1,i} = extractedSignal{1,extractLength-1};
                        cellExtendSignal{1,i+1} = extractedSignal{1,extractLength};    
                        
                        i = i+(FRAME-1);
                    else
                        cellExtendSignal{1,i} = extractedSignal{1,extractLength-1};
                        
                        i=i+1;
                    end      
            
                % calculate next start point
                cellLength=length(extractedGaid{1,1})+length(extractOtherSignal{1,1});
                start = start+cellLength-2;
           
            end
        end
        
    end
end
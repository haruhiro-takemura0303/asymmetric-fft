classdef Separation
    
    properties
    Fs
    f
    signal
    n
    end
    
    methods
        
        function param = Separation(Fs,f,signal,n)
            % Init parameter
            if nargin == 4
                param.Fs = Fs;
                param.signal = signal;
                param.n = n;
                param.f = f;
            else
                error("Input argument need three.")
            end
        end
    
        %% 時系列信号から各モード(立上り・立下り)をサンプルの傾きから抽出するヘルパー関数
        function [new_time,new_signal] = extractMotion(param)
        %{
        Args:  
            Fs      : サンプリング周波数
            signal  : テスト信号
            n       : モードの選択 push (1) / pull (2)
        
        Return:
            new_time: 選択したモードのみからなる時間配列
            new_signal: 選択したモードのみからなる振幅配列
        
        Note:
            ここでは、各モードのデータが一つなぎの時系列データとなって出力される。
            ノイズや時間軸方向の歪を考慮していない。
        %}
        %====================================================================================  
        
        % 隣接するサンプルの傾きを取得
        Diff_signal = diff(param.signal);
        time = (0:length(param.signal)-1)/param.Fs;
        
        switch param.n
            % Push の抽出
            case 1
                new_time = time(Diff_signal > 0 + 10000*eps);
                new_signal = param.signal(Diff_signal > 0 + 10000*eps);
    
            % Pull の抽出
            case 2
                new_time = time(Diff_signal < 0 - 10000*eps);
                new_signal = param.signal(Diff_signal < 0 - 10000*eps);

            otherwise
                disp('Please enter "1" for a PUSH  or "2" for a PULL');
        end
        end
        
        %% ノイズを含んだ時系列信号から各モードをサンプルの傾きから抽出するヘルパー関数
        function [new_time,new_signal,new_noise_signal] = extractNoiseMotion(param,gaid)
            %{
            Args:  
                param.signal  : ノイズを含んだテスト信号
                gaid          : ガイド波形となるノイズを含まない信号
            
            Return:
                new_time        : 選択したモードのみからなる時間配列
                new_signal      : 選択したモードのみからなる振幅配列
                new_noise_signal: 選択したモードのみからなるノイズ信号の振幅配列 
            
            Note:
                ここでは、各モードのデータが一つなぎの時系列データとなって出力される。
                ホワイトノイズ等のランダム性のノイズを考慮している。
                ノイズを含んだ信号と同様の周波数を持つ理想的なガイド信号を作成し、ガイド信号の
                立上り・立下りに合わせて、各モードを抽出する。
            %}
            %====================================================================================  
        
            Diff_motion = diff(gaid);
            time = (0:length(gaid)-1) / param.Fs;
            
            switch param.n
                % Push の抽出
                case 1
                    new_time = time(Diff_motion > 0 + 10000*eps);
                    new_signal = gaid(Diff_motion > 0 + 10000*eps);
                    new_noise_signal = param.signal(Diff_motion > 0 + 10000*eps);
                
                % Pull の抽出   
                case 2
                    new_time = time(Diff_motion < 0 - 10000*eps);
                    new_signal = gaid(Diff_motion < 0 - 10000*eps);
                    new_noise_signal = param.signal(Diff_motion < 0 - 10000*eps);

                otherwise
                    disp('Please enter "1" for a PUSH  or "2" for a PULL');
            end
            end

        %% extractMotionで抽出した1つなぎのデータをcellごとに格納
        function cellSignal = separateMotion(param)
            %{
             Args:
                > extractMotion
                　t_motion   (array) : 各モードの時間配列
                　sig_motion (array) : 各モードの振幅配列  
             
             Return:
                CellSignal (cell)  : 各モードが半周期ごとに格納されたデータ格子
            %}
            %====================================================================================    
            % extractMotionの実行
            [t_motion,sig_motion] = extractMotion(param);

            % 半周期ごとの開始点と終了点の特定
            t_start_end = 1;
            for k = 1 : length(t_motion)-1
                
                if(t_motion(k+1) - t_motion(k) > 1/param.Fs + 70*eps)
                    t_start_end = [t_start_end,k,k+1];
                end
            
            end
            t_start_end = [t_start_end, length(t_motion)];
            
            % 開始点と終了点のデータを使ってセルに格納
            cellSignal = cell(1,length(t_start_end)/2);
            for l = 1:size(cellSignal,2)
                cellSignal(1,l) = {sig_motion(t_start_end(2*l-1):t_start_end(2*l))};
            end
            
            if(nargin == 4)
                
                if(param.n == 1 && mod(param.Fs/param.f,4) == 2)
                    for i = 1:size(cellSignal,2)-1
                        cellSignal{1,i} = [cellSignal{1,i},cellSignal{1,i}(end)];
                    end
                end
                
                if(param.n == 2 && mod(param.Fs/param.f,4) == 2)
                    for i = 1:size(cellSignal,2)
                        cellSignal{1,i} = [cellSignal{1,i},cellSignal{1,i}(end)];
                    end
                end
            end
        end
        
        %% extractNoiseMotionで抽出した1つなぎのデータをcellごとに格納
        function [cellNoiseSignal,cellSignal] = separateNoiseMotion(param,gaid)
           %{
             Args:
                > extractNoiseMotion
                　t_motion       (array) : 各モードの時間配列
                　sig_motion     (array) : ガイド信号の各モードの振幅配列
                  noise_motion   (array) : ノイズ信号の各モードの振幅配列
             
             Return:
                cellSignal      (cell) : ガイド信号の各モードが半周期ごとに格納されたデータ格子
                cellNoiseSignal (cell) : ノイズ信号の各モードが半周期ごとに格納されたデータ格子
           %}
            %%====================================================================================   

            %   Detailed explanation goes here
            t_start_end = 1;

            % extractNoiseMotionの実行
            [t_motion,sig_motion,noise_motion] = extractNoiseMotion(param,gaid);
            
            for k = 1 : length(t_motion)-1
                if(t_motion(k+1) - t_motion(k) > 1/param.Fs + 7*eps)
                    t_start_end = [t_start_end,k,k+1];
                end
            end
            
            t_start_end = [t_start_end, length(t_motion)];
            cellSignal = cell(1,length(t_start_end)/2);
            cellNoiseSignal = cell(1,length(t_start_end)/2);
            
            for l = 1:size(cellSignal,2)
                cellSignal(1,l) = {sig_motion(t_start_end(2*l-1):t_start_end(2*l))};
                cellNoiseSignal(1,l) = {noise_motion(t_start_end(2*l-1):t_start_end(2*l))};
            end
        end
        
        %% 
        function [new_extend_time,new_extend_signal] = extractExtendMotion(Fs,signal,F,k)
            %{
             Args:
                > extractNoiseMotion
                　t_motion       (array) : 各モードの時間配列
                　sig_motion     (array) : ガイド信号の各モードの振幅配列
                  noise_motion   (array) : ノイズ信号の各モードの振幅配列
             
             Return:
                cellSignal      (cell) : ガイド信号の各モードが半周期ごとに格納されたデータ格子
                cellNoiseSignal (cell) : ノイズ信号の各モードが半周期ごとに格納されたデータ格子
           %}
            %%==================================================================================== 
            %%config
            sig = CreateSignal(param.Fs,param.f,param,amp);
            FRAME=3;
            T_GAID= 10;

            %%波形＋ガイドの準備
            start=1; i=1;
            for count=1:k-2;
            % reshape data
            yy=signal(start:start+Fs/F*FRAME);
            
            % make gaide
            Amp=mean(findpeaks(yy));
            [gaid,~] = sig.createCosSample(param,T_GAIS);
            
            %%波形の位置合わせ（相互相関）
            [C,lag] = xcorr(gaid,yy);
            C = C/max(C);
            
            1
            % calculate lags
            [~,I] = max(C);
            gaid = gaid(lag(I)+1:end);
            
            %% 配列整理
            [push_gaid,push_signal] = separateNoiseMotion(Fs,yy,gaid(1:Fs/F*3),1);
            [pull_gaid,pull_signal] = separateNoiseMotion(Fs,yy,gaid(1:Fs/F*3),2);
            
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




    end
end
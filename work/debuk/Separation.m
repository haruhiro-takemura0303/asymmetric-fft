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
    
        function [new_time,new_signal] = extractMotion(param)
        % 時系列信号から各モード(立上り・立下り)をサンプルの傾きから抽出するヘルパー関数
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
        %==================================================================
        
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
        
        function cellSignal = separateMotion(param)
            % extractMotionで抽出した1つなぎのデータをcellごとに格納
            %{
             Args:
                new_time   (array) : 各モードの時間配列
                new_Signal (array) : 各モードの振幅配列  
             
             Return:
                CellSignal (cell)  : 各モードが半周期ごとに格納されたデータ格子
            %}
            %==============================================================   
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
    end
end
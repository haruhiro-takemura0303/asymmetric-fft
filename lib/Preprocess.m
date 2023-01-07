classdef Preprocess
    
    properties
    fs
    f
    end
    
    methods
        
        function param = Preprocess(fs,f)
            % Init parameter
            if nargin == 2
                param.fs = fs;
                param.f = f;
            else
                error("Input argument need two.")
            end

        end
    
        %% 無音処理
        function signal_trim = trimSilence(param,signal)
         %{
         Args:　
            signal      : フィルタの次数
        
         Return:
            signal_trim : 補完フィルタの係数

         Note:
            計測信号の前後の無音区間を切り捨てる。
         %}
         %====================================================================================   
        
            flag1 = false;
            flag2 = false;
            for i = 1:len_sig
                % 前方の切り出し
                if abs(signal(i)) > max(signal)*0.8 && ~flag1
                    start_sig = i;
                    flag1 = true;
                end
                
                % 後方の切り出し
                if abs(signal(len_sig+1-i))>max(signal)*0.7 && ~flag2
                    end_sig = len_sig-i;
                    flag2 = true;
                end
                
                % 繰り返し処理の中断
                if flag1 && flag2
                    break
                end
            end
            signal_trim = signal(start_sig:end_sig);
        end
        
        %% ローパスの設計
        function [factor,delay] = makeInterpFilter(param,n,fsi,ap,ast)
         %{
         Args:　
            n           : フィルタの次数
            fs          : リサンプリング前の周波数
            fsi         : リサンプリング後の周波数
            ap          : リップルの振幅
            ast         : 阻止帯域の減衰量
        
         Return:
            param       : 補完フィルタの係数
            delay       : 群遅延
        
         Note:
            リサンプリング後の補完処理を行うフィルタを作成する。
            主な処理は "firceqrip" 関数で実行
         %}
         %====================================================================================      
        
            %ローパスフィルタの作成
            fp  = param.fs*0.4;
            
            %リップルの計算
            rp  = (10^(ap/20) - 1)/(10^(ap/20) + 1);
            rst = 10^(-ast/20);
            
            %フィルタの設計
            factor = firceqrip(n,fp/(fsi/2),[rp rst],'passedge');
            delay = mean(grpdelay(factor));
        
        end
        
        
        %% リサンプリング
        function signal_resample = resampleSignal(param,fsi,signal)
         %{
         Args:　
            fs          : リサンプリング前の周波数
            fsi         : リサンプリング後の周波数
            signal      : リサンプリング前の信号
        
         Return:
            signal_resample     : リサンプリング後の信号
        
         Note:
            リサンプリングを行い補完処理を行う。
            
            今回は整数倍のリサンプリングのみを想定。整数倍でない場合は、
            最終公倍数倍にアップサンプリングし、最大公約倍ダウンサンプリングする。
         %}
         %====================================================================================      
           %%アップサンプリングの倍率計算
           rate_up = fsi / param.fs;
        
           %fsiがfsの整数倍か確認
           if floor(rate_up) ~= rate_up
                error("The sampled frequency after resampling must be an integer multiple")
           end
        
           %%リサンプリングの実行  
           %アップサンプリング
           signal_up=upsample(signal,rate_up);
           
           %補完処理
           [factor,delay] = makeInterpFilter(param,300,fsi,0.01,160);
           signal_resample = filter(factor,1,signal_up);
        
           %FIRの群遅延分切り捨て
           signal_resample = signal_resample(delay:end);
        
        end
        
        %% 前後周期の切り捨て
        function signal_reshape = reshapeSignal(param,period,signal)
         %{
         Args:　
            fs          : リサンプリング前の周波数
            f           : リサンプリング後の周波数
            period      : リサンプリング前の信号
        
         Return:
            signal_resample     : リサンプリング後の信号
        
         Note:
            リサンプリングを行い補完処理を行う。
            
            今回は整数倍のリサンプリングのみを想定。整数倍でない場合は、
            最終公倍数倍にアップサンプリングし、最大公約倍ダウンサンプリングする。
         %}
         %====================================================================================   
            
            %%ガイド波形の作成
            gen = CreateSignal(param.fs,param.f,1);
            gaid = gen.createCosSample(period);
            
            %%新規開始点の計算
            ref_start = signal(1:length(gaid)*2);
            
            %相互相関の計算
            [c,lag] = xcorr(ref_start,gaid);
            c = c/max(c);
            [~,I] = max(c);
            start_lag = lag(I);
            
            %lagsが何周期分か確認
            start_period = round(start_lag/(param.fs/param.f));
            start_sig = start_lag + round(param.fs/param.f) * (period-start_period);
            
            %%新規終了点の計算
            ref_end = signal(length(signal)-length(gaid)*2:end);
            ref_end = flip(ref_end);
            
            %相互相関の計算
            [c,lag] = xcorr(ref_end,gaid);
            c = c/max(c);
            [~,I] = max(c);
            end_lag = lag(I);
            
            %lagsが何周期分か確認
            end_period = round(end_lag/(param.fs/param.f));
            end_sig = length(signal) - (end_lag + round(param.fs/param.f) * (period-end_period));
            
            %%波形の切り出し
            signal_reshape = signal(start_sig:end_sig);
    
        end
    end
end

classdef Visual
    
    properties
    Fs
    f
    ORG
    BLU
    GRN
    end
    
    methods  
        function param = Visual(Fs,f)
            % Init parameter
            if nargin == 4
                param.Fs = Fs;
                param.f = f;
                param.ORG = [0.8510    0.3255    0.0980];
                param.BLU = [0    0.4471    0.7412];
                param.GRN = [0.4667    0.6745    0.1882];
            else
                error("Input argument need three.")
            end
        end
        
        %% FFT結果をプロットする
        function plotFFT(param,signal,TYPE,f_lim)
            
            % FFT実行
            L=length(signal);
            Y = fft(signal); 
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            freq = param.Fs*(0:(L/2))/L;
            
            %FFT 結果描画
            if nargin == 2
                f_lim = param.Fs/2;
            end


            if TYPE == "PULL"
                COLOR = param.BLU;
                TITLE = "Pull Motion";

            elseif TYPE == "PUSH"
                COLOR = param.ORG;
                TITLE = "Push Motion";
            
            elseif TYPE == "ORIGIN"
                COLOR = param.GRN;
                TITLE = "Original Signal";
            end



            plot(freq,mag2db(P1),'Linewidth',2.0)
            
            title(TITLE)
            xlabel('f [Hz]')
            ylabel('Power[db]')
            
            ylim([-350,0])
            xlim([0,f_lim])
            
            ax=gca;
            ax.ColorOrder = COLOR; 
            ax.FontSize = 10;
        
        end
        
        %% 時系列信号をplotする
        function plotSignal(param)
            
        
        end
    end
end
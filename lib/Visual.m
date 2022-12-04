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
            if nargin == 2
                param.Fs = Fs;
                param.f = f;
                param.ORG = [0.8510    0.3255    0.0980];
                param.BLU = [0    0.4471    0.7412];
                param.GRN = [0.4667    0.6745    0.1882];
            else
                error("Input argument need three.")
            end
        end

        %% FFTの計算
        function [freq,mag] = calcFFT(param,signal)
            % FFT実行
            L=length(signal);
            Y = fft(signal); 
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            freq = param.Fs*(0:(L/2))/L;
            mag = mag2db(P1);
        end

        %% FFT結果をプロットする
        function plotFFT(param,signal,TYPE,f_lim)

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
            
            else
                error("TYPE is PULL or PUSH or ORIGIN" )

            end
            
            % FFT
            [freq,mag] = calcFFT(param,signal);
            
            % プロット設定
            plot(freq,mag,'Linewidth',1.5);
            ax = gca;
            ax.ColorOrder = COLOR;
            
            title(TITLE)
            xlabel('Frequency [Hz]')
            ylabel('Power [db]')
            
            ylim([-350,0])
            xlim([0,f_lim])
            
            % GCF設定
            fig = gcf;
            fig.Units         = "centimeters";
            fig.PaperUnits    = "centimeters";
            fig.PaperType     = "a4";
            fig.PaperPosition = [0, 0, 15, 12];
            fig.Position      = [0, 0, 15, 12];
            
            fs = 12;
            fig = gcf;
            nAxes = length(fig.Children);
            for i=1:nAxes
                set(fig.Children(i), "FontName", "Times New Roman")
                set(fig.Children(i), "FontSize", fs)
                set(fig.Children(i), 'TitleFontSizeMultiplier', 1)
                set(fig.Children(i), 'TitleFontWeight', 'normal')
                fig.Children(i).XLabel.FontSize = fs;
                fig.Children(i).YLabel.FontSize = fs;
                fig.Children(i).ZLabel.FontSize = fs;
            end

        end
        
        %% Subplot の座標を所望の条件からより細かく計算するヘルパー関数 
        function axn = setAxis(param,num, row, col, left_m, bot_m, ver_r, col_r)
            %{
            row     : subplot行数
            col     : subplot列数
            left_m  : 左側余白の割合
            bot_m   : 下側余白の割合
            ver_r   : 縦方向余裕 
            col_r   : 横方向余裕 
            %}
            %=====================================================================
            % Position は、各Axes に対し、 [左下(x), 左下(y) 幅, 高さ] を指定
            axn = [(1-left_m)*(mod(num-1,col))/col + left_m ,...
                 (1-bot_m)*(1-ceil(num/col)/(row)) + bot_m ,...
                 (1-left_m)/(col*col_r ),...
                 (1-bot_m)/(row*ver_r)];
        end

        %% FFT結果をpull,push,origin並べてプロットする
        function plotFFT3(param,data_pull,data_push,data_org,f_lim)
            
            % 配置設定
            figure;
            fig = gcf;
            figure_size = [ 0, 0, 1000, 250];
            set(fig, 'Position', figure_size);
            row = 1; col = 3; 
            left_m = 0.09; bot_m = 0.2; 
            ver_r = 1.2; col_r = 1.35; 
            
            % Pull
            ax = axes('Position',setAxis(param,1,row,col,left_m,bot_m,ver_r,col_r));
            [freq,mag] = calcFFT(param,data_pull);
            plot(ax,freq,mag,'Linewidth',1.5);
            ax = gca;
            ax.ColorOrder = param.BLU;
            
            title("Pull Motion")
            xlabel('Frequency [Hz]')
            ylabel('Power [db]')
            
            ylim([-350,0])
            xlim([0,f_lim])

            % Push
            ax = axes('Position',setAxis(param,2,row,col,left_m,bot_m,ver_r,col_r));
            [freq,mag] = calcFFT(param,data_push);
            plot(ax,freq,mag,'Linewidth',1.5);
            ax.ColorOrder = param.ORG;
           
            title("Push Motion")
            xlabel('Frequency [Hz]')
            ylabel('Power [db]')
            
            ylim([-350,0])
            xlim([0,f_lim])
            
            % Original
            ax = axes('Position',setAxis(param,3,row,col,left_m,bot_m,ver_r,col_r));
            [freq,mag] = calcFFT(param,data_org);
            plot(ax,freq,mag,'Linewidth',1.5);
            ax = gca;
            ax.ColorOrder = param.GRN;
            
            title("Original")
            xlabel('Frequency [Hz]')
            ylabel('Power [db]')
            
            ylim([-350,0])
            xlim([0,f_lim])

            % gcf設定
            fs = 10;
            fig = gcf;
            nAxes = length(fig.Children);
            for i=1:nAxes
                set(fig.Children(i), "FontName", "Times New Roman")
                set(fig.Children(i), "FontSize", fs)
                set(fig.Children(i), 'TitleFontSizeMultiplier', 1)
                set(fig.Children(i), 'TitleFontWeight', 'normal')
                fig.Children(i).XLabel.FontSize = fs;
                fig.Children(i).YLabel.FontSize = fs;
                fig.Children(i).ZLabel.FontSize = fs;
            end

        end
        %% 信号をプロットする
        function plotSignal(param,signal)
            plot(signal)
            ylabel("Amplitude")
            xlabel("Sample")

           % gcf設定
            fig = gcf;
            fig.Units         = "centimeters";
            fig.PaperUnits    = "centimeters";
            fig.PaperType     = "a4";
            fig.PaperPosition = [0, 0, 15, 12];
            fig.Position      = [0, 0, 15, 12];
            
            fs = 12;
            fig = gcf;
            nAxes = length(fig.Children);
            for i=1:nAxes
                set(fig.Children(i), "FontName", "Times New Roman")
                set(fig.Children(i), "FontSize", fs)
                set(fig.Children(i), 'TitleFontSizeMultiplier', 1)
                set(fig.Children(i), 'TitleFontWeight', 'normal')
                fig.Children(i).XLabel.FontSize = fs;
                fig.Children(i).YLabel.FontSize = fs;
                fig.Children(i).ZLabel.FontSize = fs;
            end

        end
        %% 各モードの時系列信号をplotする
        function plotEachSignal(param,cellSignal,TYPE)
            
            %横軸のサンプル数配列を作成
            [~,col] = cellfun(@size,cellSignal);
            t = 1:sum(col)*2;
            
            %信号配列を成型.各区間の間には見やすいように空白を追加.
            signal = zeros(1,length(t));
            start = 1;
            if TYPE == "PULL"
                COLOR = param.BLU;
                for i =1:length(col)
                    cell_len = length(cellSignal{i});
                    signal(start:start+2*cell_len-1) = cat(2,cellSignal{i},NaN(1,cell_len));
                    start = start + 2*cell_len;
                end

            elseif TYPE == "PUSH"
                COLOR = param.ORG;
                for i =1:length(col)
                    cell_len = length(cellSignal{i});
                    signal(start:start+2*cell_len-1) = cat(2,NaN(1,cell_len),cellSignal{i});
                    start = start + 2*cell_len;
                end

            else
                error("TYPE is PULL or PUSH")
            end
            
            % plot
            scatter(t,signal)
            title(TYPE)
            xlabel('Frequency [Hz]')
            ylabel('Power [db]')

            % gca設定
            ax = gca;
            ax.ColorOrder = COLOR;
               
            % gcf設定
            fig = gcf;
            fig.Units         = "centimeters";
            fig.PaperUnits    = "centimeters";
            fig.PaperType     = "a4";
            fig.PaperPosition = [0, 0, 15, 12];
            fig.Position      = [0, 0, 15, 12];
            
            fs = 12;
            fig = gcf;
            nAxes = length(fig.Children);
            for i=1:nAxes
                set(fig.Children(i), "FontName", "Times New Roman")
                set(fig.Children(i), "FontSize", fs)
                set(fig.Children(i), 'TitleFontSizeMultiplier', 1)
                set(fig.Children(i), 'TitleFontWeight', 'normal')
                fig.Children(i).XLabel.FontSize = fs;
                fig.Children(i).YLabel.FontSize = fs;
                fig.Children(i).ZLabel.FontSize = fs;
            end

        end
    end
end
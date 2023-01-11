classdef Reconstruct
    % 分割した信号を反転して再合成

    properties
        period %合成する周期数
    end
    
    methods
        function param = Reconstruct(period)
        % コンストラクタ
            param.period = period;
        end

        function cellReverseSignal = reverseHorizontal(param,cellSignal,n)
        % 切り分けた各周期の波形を一周期ごとに水平方向に反転
        %
        %Args:
        %   cellSignal  : 各周期ごとのサンプルが格納されたcell配列
        %   period      : 使用する周期数の指定
        %   n           : モードの選択 push (1) / pull (2)
        %
        %Retuen:
        %   cellReverseSignal   : 反転後の各周期ごとのサンプルが格納されたcell配列
        %
        %Note:
        %   出力はcell配列である。時系列信号でほしい場合はreconstructメソッドを使う。
        % 
        %======================================================================
            % 入力cellSignalのサイズの確認
            if length(cellSignal) < param.period
                error("The number of cycles of the input cellSignal is less than the specified number of period.")
            end
            
            % cellReverseSignalの宣言
            cellReverseSignal = cell(1,param.period);
            
            % 時間軸方向へ水平方向反転
            switch n
                % PUSH配列の水平方向反転
                case 1
                    % 奇数の水平方向反転
                    for i = 1:param.period
                        if mod(i,2) == 1
                            cellReverseSignal{1,i} = flip(cellSignal{1,i}(2:end));
                        
                        elseif mod(i,2) == 0
                            cellReverseSignal{1,i} = cellSignal{1,i}(1:end-1);
                        end
                    end
                
                % PULL配列の水平方向反転
                case 2
                     % 偶数の水平方向反転
                     for i = 1:param.period
                        if mod(i,2) == 0
                            cellReverseSignal{1,i} = flip(cellSignal{1,i}(2:end));
                        
                        elseif mod(i,2) == 1
                            cellReverseSignal{1,i} = cellSignal{1,i}(1:end-1);
                        end
                     end
        
                otherwise
                    error('Please enter "1" for a PUSH  or "2" for a PULL');
            end
         end
    
         %% 垂直方向に反転
         function cellReverseSignal = reverseVertical(param,cellSignal,n)
         % 切り分けた各周期の波形を一周期ごとに垂直方向に反転
         %
         %Args:
         %   cellSignal  : 各周期ごとのサンプルが格納されたcell配列
         %   period      : 使用する周期数の指定
         %   n           : モードの選択 push (1) / pull (2)
         %
         %Retuen:
         %   cellReverseSignal   : 反転後の各周期ごとのサンプルが格納されたcell配列
         %
         %Note:
         %   出力はcell配列である。時系列信号でほしい場合はreconstructメソッドを使う。
         % 
         %======================================================================
            % 入力cellSignalのサイズの確認
            if length(cellSignal) < param.period
                error("The number of cycles of the input cellSignal is less than the specified number of period.")
            end
            
            % cellReverseSignalの宣言
            cellReverseSignal = cell(1,param.period);
            
            % 時間軸方向へ垂直方向反転
            switch n
                % PUSH配列の垂直方向反転
                case 1
                    % 奇数の垂直方向反転
                    for i = 1:param.period
                        if mod(i,2) == 1
                            cellReverseSignal{1,i} = -cellSignal{1,i}(1:end-1);
                        
                        elseif mod(i,2) == 0
                            cellReverseSignal{1,i} = cellSignal{1,i}(1:end-1);
                        end
                    end
                
                % PULL配列の垂直方向反転
                case 2
                     % 偶数の垂直方向反転
                     for i = 1:param.period
                        if mod(i,2) == 0
                            cellReverseSignal{1,i} = -cellSignal{1,i}(1:end-1);
                        
                        elseif mod(i,2) == 1
                            cellReverseSignal{1,i} = cellSignal{1,i}(1:end-1);
                        end
                     end
        
                otherwise
                    error('Please enter "1" for a PUSH  or "2" for a PULL');
            end
         end
         %% cell配列の結合
         function catSignal = catArray(param,cellSignal)
         % cell配列を結合して一つの時系列データを作成
         %
         %Args:
         %   cellSignal  : 各周期ごとのサンプルが格納されたcell配列
         %
         %Retuen:
         %   catSignal   : 結合後の時系列信号
         %
         %Note:
         %   分割し、反転した各周期の波形はcell配列で管理している。
         %   この配列を結合し一つの時系列データを作成する。
         %======================================================================
            % 結合後配列の宣言
            [~,col] = cellfun(@size,cellSignal);
            catSignal = zeros(1,sum(col));
            
            % 結合後配列への格納
            start = 1;
            for i = 1:length(cellSignal)
                catSignal(start:start+col(i)-1) = cellSignal{1,i};
                start = start + col(i);
            end
         end
        
         %% 反転＋結合
         function reconstructSignal = reconstructHorizontal(param,cellSignal,n)
         % 水平方向への反転・結合
             reconstructSignal = catArray(param,reverseHorizontal(param,cellSignal,n));
         end
          
         function reconstructSignal = reconstructVertical(param,cellSignal,n)
         % 垂直方向への反転・結合
             reconstructSignal = catArray(param,reverseVertical(param,cellSignal,n));
         end

    end
end
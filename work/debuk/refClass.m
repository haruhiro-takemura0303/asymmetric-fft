classdef refClass < handle
    properties
        sum
    end

    methods
        function obj = refClass()
            % コンストラクタ
            obj.sum = 0;
        end

        function  sum = add(obj, num)
            % これまで入力された値の総和を返す
            %obj.sum = obj.sum + num;
            sum = sum+num;
        end
    end
end
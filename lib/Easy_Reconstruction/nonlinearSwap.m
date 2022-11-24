function [outputSignal] = nonSwapTest(linearSignal,nonlinearSignal,n)
%NONSWAPTEST Swaps nonlinear components to linear ones
%   n:  (1) Swap to linear Push Components
%       (2) Swap to nonlinear Pull Components
outputSignal = cell(1,size(linearSignal,2)+size(nonlinearSignal,2));
switch n
    case 1
        for k = 1:size(linearSignal,2)
            outputSignal{1,2*k-1} = linearSignal{1,k};
        end
        for k = 1:size(nonlinearSignal,2)
            outputSignal{2*k} = nonlinearSignal{1,k};
        end
    case 2
        for k = 1:size(nonlinearSignal,2)
            outputSignal{1,2*k-1} = nonlinearSignal{1,k};
        end
        for k = 1:size(linearSignal,2)
            outputSignal{2*k} = linearSignal{1,k};
        end
end
        
        
end



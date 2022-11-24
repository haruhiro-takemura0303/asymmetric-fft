function [cellSignal] = SeparateMotion(Fs,signal,n,f)
%Selection of required samples using extractMotion
switch n
    case 1 %Push-samples
        [t_motion,sig_motion] = ExtractMotion(Fs,signal,1);
    case 2 %Pull-samples
        [t_motion,sig_motion] = ExtractMotion(Fs,signal,2);
end
%Alternate determination of the start and end points
...of the signal sections
    t_start_end = 1;
    for k = 1 : length(t_motion)-1
        
    if(t_motion(k+1) - t_motion(k) > 1/Fs + 70*eps)
        t_start_end = [t_start_end,k,k+1];
    end
    
    end
    t_start_end = [t_start_end, length(t_motion)];
    
    %Create a cell array and insert the push/pull sections using
    ...the collected points
        cellSignal = cell(1,length(t_start_end)/2);
    for l = 1:size(cellSignal,2)
        cellSignal(1,l) = {sig_motion(t_start_end(2*l-1):t_start_end(2*l))};
    end
    
    if(nargin == 4)
        
        if(n == 1 && mod(Fs/f,4) == 2)
            for i = 1:size(cellSignal,2)-1
                cellSignal{1,i} = [cellSignal{1,i},cellSignal{1,i}(end)];
            end
        end
        
        if(n == 2 && mod(Fs/f,4) == 2)
            for i = 1:size(cellSignal,2)
                cellSignal{1,i} = [cellSignal{1,i},cellSignal{1,i}(end)];
            end
        end
    end
    
end


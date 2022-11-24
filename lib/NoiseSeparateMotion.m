function [cellNoiseSignal,cellSignal] = NoiseSeparateMotion(Fs,signal,noise,n,f)
%NEWSEPARATEMOTION Summary of this function goes here
%   Detailed explanation goes here
t_start_end = 1;
switch n
    case 1
        [t_motion,sig_motion,noise_motion] = NoiseExtractMotion(Fs,signal,noise,1);
    case 2
        [t_motion,sig_motion,noise_motion] = NoiseExtractMotion(Fs,signal,noise,2);
end

        for k = 1 : length(t_motion)-1
            if(t_motion(k+1) - t_motion(k) > 1/Fs + 7*eps)
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
        
%         if(nargin == 4)
%             
%         if(n == 1 && mod(Fs/f,4) == 2)
%             for i = 1:size(cellSignal,2)
%                 cellSignal{1,i} = [cellSignal{1,i},cellSignal{1,i}(end)];
%             end
%         end
% 
%         if(n == 2 && mod(Fs/f,4) == 2)
%             for i = 1:size(cellSignal,2)
%                 cellSignal{1,i} = [cellSignal{1,i},cellSignal{1,i}(end)];
%             end
%         end 
%         end
end


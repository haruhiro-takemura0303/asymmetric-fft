classdef separate
    
    properties
    Fs
    signal
    n
    new_time
    new_signal
    end
    
    methods
        function param = separate(Fs,signal,n)
            % Init parameter
            if nargin == 3
                param.Fs = Fs;
                param.signal = signal;
                param.n = n;
            else
                error("Input argument need 3")
            end
        end
    
        function [new_time,new_signal] = ExtractMotion(Fs,signal,n)
        %ExtactMotion divides a signal in its rising/falling section. 
        %{
        Args:  
            Fs      : Sampling Frequency
            signal  : signal sampels
            n       : select type of motion push (1) / pull (2)
        
        Return:
            new_time: Time samples of selected samples
            new_signal: Selected samples based on the user choice.
        
        Note:
            In orde to find the point Where change pull and push,
            calculate differentiation.
        %}
        
        %Calculation differentation between adjacent samples.
        Diff_signal = diff(signal);
        time = (0:length(signal)-1)/Fs;
        
        %Separation of the first point of the signal and time for special treatment
        signal_end = signal(1:end);
        time_end = time(1:end);
        
        switch n
            %Sample-Selection for Push-Reconstruction
            case 1
                new_time = time_end(Diff_signal > 0 + 10000*eps);
                new_signal = signal_end(Diff_signal > 0 + 10000*eps);
    
            %Sample-Selection for Pull-Reconstruction
            case 2
                new_time = time_end(Diff_signal < 0 - 10000*eps);
                new_signal = signal_end(Diff_signal < 0 - 10000*eps);
            %Error case    
            otherwise
                disp('Please enter "1" for a PUSH  or "2" for a PULL');
        end
        end
        
    
    
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
        


function [new_time,new_signal] = ExtractMotion(Fs,signal,n)
%ExtactMotion divides a signal in its rising/falling components. 
...The samples are returned with their respective dates.
%{
Input:  Fs: Sampling Frequency
        signal: signal sampels
        n: Selection-indicator: Rising (1) / Falling (2)
Output: new_time: Time samples of selected samples
        new_signal: Selected samples based on the user choice.

In order to obtain the respective samples, a numerical differentiation is 
performed at the input signal in used to determine the corresponding slope 
values and to assign them to the samples.
%}
%Calculation of the numerical derivation for the allocation of samples
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
        %Restore the first point for the push reconstruction 
%          new_time = [time(1),new_time];
%         new_signal = [signal(1),new_signal];
    %Sample-Selection for Pull-Reconstruction
   KK=1;
    case 2
        new_time = time_end(Diff_signal < 0 - 10000*eps);
        new_signal = signal_end(Diff_signal < 0 - 10000*eps);
    %Error case    
    otherwise
        disp('Please insert either "1" for a PUSH motion or "2" for a PULL motion!');
end
end

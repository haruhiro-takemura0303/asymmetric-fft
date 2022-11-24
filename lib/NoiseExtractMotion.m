function [new_time,new_motion,new_noiseMotion] = NoiseExtractMotion(Fs,motion,noiseMotion,n)
%EXTRACTMOTION Summary of this function goes here
%   Detailed explanation goes here


Diff_motion = diff(motion);
% motion_end = motion(2:end);
% noiseMotion_end = noiseMotion(2:end);
time = (0:length(motion)-1)/Fs;
% time_end = time(1:end);

switch n
    case 1
        new_time = time(Diff_motion > 0 + 10000*eps);
%         new_time = [time(1),new_time];
        new_motion = motion(Diff_motion > 0 + 10000*eps);
%         new_motion = [motion(1),new_motion];
        new_noiseMotion = noiseMotion(Diff_motion > 0 + 10000*eps);
%         new_noiseMotion = [noiseMotion(1),new_noiseMotion];
        
    case 2
        new_time = time(Diff_motion < 0 - 10000*eps);
        new_motion = motion(Diff_motion < 0 - 10000*eps);
        new_noiseMotion = noiseMotion(Diff_motion < 0 - 10000*eps);
    otherwise
        disp('Please insert either "1" for a PUSH motion or "2" for a PULL motion!');
end

end


function [new_time,new_motion,new_noiseMotion] = PeakExtractMotion(Fs,motion,noiseMotion,n)
%EXTRACTMOTION Summary of this function goes here
%   Detailed explanation goes here

% detect peaks point
[pks,locs]=findpeaks(motion);
Diff_motion = diff(motion);
time = (0:length(motion)-1)/Fs;

switch n
    case 
        new_time = time(Diff_motion > 0 + 10000*eps);
        new_motion = motion(Diff_motion > 0 + 10000*eps);
        new_noiseMotion = noiseMotion(Diff_motion > 0 + 10000*eps);
        
    case 2
        new_time = time(Diff_motion < 0 - 10000*eps);
        new_motion = motion(Diff_motion < 0 - 10000*eps);
        new_noiseMotion = noiseMotion(Diff_motion < 0 - 10000*eps);
    otherwise
        disp('Please insert either "1" for a PUSH motion or "2" for a PULL motion!');
end

end

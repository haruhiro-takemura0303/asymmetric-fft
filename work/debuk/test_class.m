%% make sound
f = 1e3;
Fs = 48e3;
t = 0:1/Fs:1;
signal = cos(2*pi*f*t);

%% class_test

% make instance
S = Separation(Fs,f,signal,1);
A = S.separateMotion()

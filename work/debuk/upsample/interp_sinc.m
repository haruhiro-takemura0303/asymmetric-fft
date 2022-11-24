upfac = 7;
alpha = 0.5;
h1 = intfilt(upfac,2,alpha);

lowp = fir1(40,alpha);
freqz(lowp);

rng('default')
x = filter(lowp,1,randn(200,1));
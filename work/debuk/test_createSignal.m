test = CreateSignal(48e3,1e3,1)

[y,t] = test.createSinSample(10);

scatter(t,y)

test.createDistorionSignal(6,50,10,y)
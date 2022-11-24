clear all
close all
data=load('data/2021.09.28/cos_500n.mat');

timed=data.Scope{4,1};
signald=data.Scope{4,2};

figure(1)
plot(timed,signald);
xlabel('time[s]')
ylabel('Amplitude')

%% detection start point
Fs=48e3;
F=500;
k=10;

[pks,locs] = findpeaks(signald);

n=1;
for i=1:length(pks)
if pks(i)>0.8
    start(1,n)=pks(i);
    start(2,n)=locs(i);
    n=n+1;
end
end

signal=signald(start(2,3) : start(2,3) + (Fs/F)*k);
time=0:1/Fs:k/F;

figure(2)
hold on
plot(timed,signald);
scatter(start(2,:)'/Fs,start(1,:)');
xlabel('time[s]')
ylabel('Amplitude')
xlim([1.3,1.5])
hold off
%% check Fs
for m=1:1:length(signald)-1
    
A(m)=1/(timed(m+1)-timed(m));

end

figure(3)
plot(time,signal);
xlabel('time[s]')
ylabel('Amplitude')
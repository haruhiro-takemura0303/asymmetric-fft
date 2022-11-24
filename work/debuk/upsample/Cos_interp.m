clear all

f = 1000;
Fs = e3;
FsI = 48e3;
Fup=lcm(Fs,FsI)/Fs;
Fdun=lcm(Fs,FsI)/FsI;
amp = 1;

t=0:1/Fs:1;
ts=0:1/FsI:1;
x=cos(2*pi*f*t);

y=interp(x,Fup);
y=decimate(y,Fdun);


subplot(2,1,1)
stem(t,x,'filled','MarkerSize',3)
grid on
xlabel('Sample Number')
ylabel('Original')
xlim([0,1.5/f]);

subplot(2,1,2)
stem(ts,y(1:end-1),'filled','MarkerSize',3)
grid on
xlabel('Sample Number')
ylabel('Interpolated')
xlim([0,1.5/f]);
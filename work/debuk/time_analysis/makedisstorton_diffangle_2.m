clear all

%% 振幅確定

% 振幅傾斜
Kd=6; %db/oct　
D2=-70; %二番目の倍音のゲイン
N=10; %倍音の次数

% 周波数設定
f=1000;
Fs=48000;

k = 10;       %Signal with 2000 periods
kn = floor((Fs/f)*k +1);  %Create amount of samples
t = (0:kn-1)/Fs;          %Create time samples

i=2; for n=2:1:N
Amp(i)=10^((D2-Kd*log2(n/2))/20);

i=i+1;
end

Amp(1)=1;

%% 合成
w=zeros(1,10);
w(1,1)=0;

w(1,2:10)=rand(1,9);

y=0; i=1; 
for i=1:N
 
 yn(i,:)=Amp(i)*cos(2*pi*f*i*t+w(i)*pi);
 y=yn(i,:)+y;
 
end


signald=y;
signal=yn(1,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Time domain Separaton

[cell_push,cell_pull]=dataSepatateMotion(Fs,signald,f,k);



for i=1:length(cell_push)

    if i<length(cell_push)
        cell_pull{1,i}(1,end+1) = cell_push{1,i}(1,1);
        cell_push{1,i}(1,end+1) = cell_pull{1,i+1}(1,1);
   
    else
        cell_pull{1,i}(1,end+1) = cell_push{1,i}(1,1);
    end
    
end
 
%% reshape signal

for i = 1:length(cell_push)
    
    if mod(i,2) == 1
        cell_pull{1,i}(:,end) = [];
    
    else mod(i,2) == 0
        cell_pull{1,i}(:,1)   = [];
        
    end
    
end

for i = 1:length(cell_push)-1
    
    if mod(i,2) == 1
        cell_push{1,i}(:,1) = [];
    
    else mod(i,2) == 0
        cell_push{1,i}(:,end) =   [];
        
    end
    
end

%% Inversion time-domain
for i = 1:length(cell_pull)
    
    if mod(i,2) == 0
        cell_pull{1,i} = flip(cell_pull{1,i});
    end
end
   
for i = 1:length(cell_push)
    
    if mod(i,2) == 1
        cell_push{1,i} = flip(cell_push{1,i});  
    end
end

signal_pull = readArray(cell_pull);
signal_push = readArray(cell_push);

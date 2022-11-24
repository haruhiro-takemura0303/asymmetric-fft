%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%位相の異なる非線形信号を作成する。
%%時間軸方向の合成でくっつける
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
%% 位相の異なる信号を作成する

% 振幅傾斜
kd=6; %db/oct　
D2e=-80; %二番目の倍音のゲイン
D2o=-60;
N=10; %倍音の次数

% 周波数設定
f  = 1000;
Fs = 48000;
k  = 8;

% 非線形波形の作成
[signald, signal] = make_asyn_distortion_diffangle (Fs,f,k,kd,D2e,D2o,N);


%% Time domain Separaton

cell_push=NoiseSeparateMotion(Fs,signal,signald,1,f);
cell_pull=NoiseSeparateMotion(Fs,signal,signald,2,f);


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

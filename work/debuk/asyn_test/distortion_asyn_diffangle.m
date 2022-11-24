clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%立上り立下りで非線形性の異なる非対称信号の作成
%%%立上り・立下りで偶数次・奇数次の異なる非線形信号を作成（位相も異なる）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 位相の異なる信号を二種類作成する

% 周波数設定
f  = 1000;
Fs = 48000;
k  = 1000;

% 振幅傾斜
kd=6; %db/oct　
N=10; %倍音の次数

%%%非線形歪1%%%%%%%%%%%%%%%

% 振幅傾斜
D2e=-60; %二番目の倍音(even)
D2o=-80; %二番目の倍音(odd)

% 非線形波形の作成
[signald1, signal1] = make_asyn_distortion_diffangle (Fs,f,k,kd,D2e,D2o,N);

%%%非線形歪2%%%%%%%%%%%%%%%%%

D2e=-80; %二番目の倍音(even)
D2o=-60; %二番目の倍音(odd)

[signald2, signal2] = make_asyn_distortion_diffangle (Fs,f,k,kd,D2e,D2o,N);

%% 立上り・立下り抽出, 反転

%%%非線形歪1%%%%%%%%%%%%%%%
cell1_push = NoiseSeparateMotion(Fs,signal1,signald1,1);
cell1_pull = NoiseSeparateMotion(Fs,signal1,signald1,2);

%%%非線形歪2%%%%%%%%%%%%%%%%%
cell2_push = NoiseSeparateMotion(Fs,signal2,signald2,1);
cell2_pull = NoiseSeparateMotion(Fs,signal2,signald2,2);


%% 非対称合成


%%% PULL:1　push:2 %%%%%%%%%%%%%%%
signald12 = readArray(nonlinearSwap(cell1_pull,cell2_push,1));

%%% PULL:2　push:1 %%%%%%%%%%%%%%%
signald21 = readArray(nonlinearSwap(cell2_pull,cell1_push,1));

%% 立上り・立下り分析
[cell_pull,cell_push] = makeinv_time_domaine (signald21,signal2,Fs,f);

signal_pull = readArray(cell_pull);
signal_push = readArray(cell_push);
signald     = signald12;

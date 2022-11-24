%%%理想波形との差分解析をしてみよう。
%%%
%%%テスト波形ー立上り波形
%%%テスト波形ー立下り波形
%%%
run diff_distortionAB

%% 立上り・立下り分解
[cell_pull,cell_push] = makeinv_time_domaine (signald,signal,Fs,f);

signal_pull = readArray(cell_pull);
signal_push = readArray(cell_push);



%% テスト波形ー立上り
signald=signald(1:length(signal)/2);



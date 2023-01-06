clear all;
%{
  計測データからデータセットを作成する[.mat]
    %計測した各データを一つのデータセットにまとめる
    %データセットはstrct形式で作成される。
%}

%----------------------------------config-------------------------------------------
name = "c";
tl_num = 2;
RAW_PATH = "./data/raw/2022";
SAVE_PATH = "./data/processed";

%----------------------------------Score list----------------------------------------
polar_list1  = ["aa" "ab" "ba" "bb"]; %cl,co 
polar_list2  = ["c" "d"]; %uni

freq_list    = ["40" "1000" "10000" "20000"];

vpp_list_a   = ["0.2" "1" "5" "15" "50"]; %amp_a
vpp_list_b   = ["0.2" "1" "5" "15"]; %amp_b
vpp_list_c   = ["0.2" "0.9" "4.5" "14" "50"]; %amp_c

%------------------------------------main-------------------------------------------

%%pathの宣言
amp_name = "amp_"+name;
data_path = RAW_PATH +"/"+num2str(tl_num)+"/"+amp_name;

%%データセットの確認
if exist(SAVE_PATH+"/"+amp_name+"/clean.mat","file") == 2
   load(SAVE_PATH+"/"+amp_name+"/clean.mat");
end

if exist(SAVE_PATH+"/"+amp_name+"/commercial.mat","file") == 2
   load(SAVE_PATH+"/"+amp_name+"/commercial.mat");
end

if exist(SAVE_PATH+"/"+amp_name+"/uni.mat","file") == 2
   load(SAVE_PATH+"/"+amp_name+"/uni.mat");
end

%%vppリストの読み込み
if name == "a"
    vpp_list = vpp_list_a;

elseif name == "b"
    vpp_list = vpp_list_b;

elseif name == "c"
    vpp_list = vpp_list_c;
end

%%データセットの作成
for m = 1:length(freq_list)

    for n = 1:length(vpp_list)

        for k = 1:length(polar_list1)

            % クリーン電源
            data_strct = load(data_path+"/"+num2str(tl_num)+"_"+name+"_cl_"+polar_list1(k)+"_"+vpp_list(n)+"_"+freq_list(m)+".mat");
            clean.(polar_list1(k)).freq(m).vpp(n).trial(tl_num).signal = read_signal(data_strct);

            % 商用電源
            data_strct = load(data_path+"/"+num2str(tl_num)+"_"+name+"_co_"+polar_list1(k)+"_"+vpp_list(n)+"_"+freq_list(m)+".mat");
            commercial.(polar_list1(k)).freq(m).vpp(n).trial(tl_num).signal = read_signal(data_strct);

        end

        for k = 1:length(polar_list2)

            % 同一電源
            data_strct = load(data_path+"/"+num2str(tl_num)+"_"+name+"_uni_"+polar_list2(k)+"_"+vpp_list(n)+"_"+freq_list(m)+".mat");
            uni.(polar_list2(k)).freq(m).vpp(n).trial(tl_num).signal = read_signal(data_strct);

        end
    end
end



%%保存

%フォルダの確認
if exist(SAVE_PATH+"/"+amp_name,"dir") == 0
    mkdir(SAVE_PATH+"/"+amp_name)
end

%保存
save(SAVE_PATH+"/"+amp_name+"/clean.mat","clean",'-v7.3');
save(SAVE_PATH+"/"+amp_name+"/commercial.mat","commercial",'-v7.3');
save(SAVE_PATH+"/"+amp_name+"/uni.mat","uni",'-v7.3');


%---------------------------------function-------------------------------------------

function signal = read_signal(data_strct)
    % 要素の名称を抜き出し
    name = fieldnames(data_strct);
    name = string(name);

    % 格納配列の宣言
    n = length(data_strct.(name(1)){4,2});
    d = length(name);
    signal = zeros(n,d);
    
    % 格納
    for i = 1:length(name)
         signal(:,i) = data_strct.(name(i)){4,2};
    end
end
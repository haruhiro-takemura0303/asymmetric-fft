function [new_signal] = distorion(Kd,gain2,hnumber,data)
%% 入力条件

Kd=Kd; %db/oct　
D2=gain2; %二番目の倍音のゲイン
N=hnumber; %倍音の次数

X=data;

%% 先行研究モデル(+THD) 1:偶数　2:奇数


%%倍音次数,振幅倍率の設定%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%倍音の振幅倍率
i=2; for n=2:2:N;

N_c(i)=n; %倍音の次数
Amp_c(i)=10^((D2-Kd*log2(n/2))/20); %倍音の振幅倍率

i=i+1;

end
N_c(1)=1; Amp_c(1)=1;


%%音源の作成%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S_e1=0; S_e2=0; S_e3=0; 
S_o1=0; S_o2=0; S_o3=0; 

Sound_even=0; Sound_odd=0;



%% 多項式モデル(+THD+IMD)


%%多項式近似の係数導出(MAthematica)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11

eqn_even=[A1==Amp_c(1),...
        1/512*(-210*A10-256*A2-256*A4-240*A6-224*A8)==Amp_c(2),...
        1/512*(120*A10+64*A4+96*A6+112*A8)==Amp_c(3),...
        1/512*(-45*A10-16*A6-32*A8)==Amp_c(4),...
        1/512*(10*A10+4*A8)==Amp_c(5),...
        -(1/512)*A10==Amp_c(6)];
  
S_even=solve(eqn_even,[A1,A2,A4,A6,A8,A10]);

eqn_odd=[(1024*A1+462*A11+768*A3+640*A5+560*A7+504*A9)/1024==Amp_c(1),...
        (-330*A11-256*A3-320*A5-336*A7-336*A9)/1024==Amp_c(2),...
        (165*A11+64*A5+112*A7+144*A9)/1024==Amp_c(3),...
        (-55*A11-16*A7-36*A9)/1024==Amp_c(4),...
        (11*A11+4*A9)/1024==Amp_c(5),...
        -(A11/1024) ==Amp_c(6)];

S_odd=solve(eqn_odd,[A1,A3,A5,A7,A9,A11]);

%偶数次多項式の係数
p1_e=S_even.A1; p2=S_even.A2; p4=S_even.A4;
p6=S_even.A6;   p8=S_even.A8; p10=S_even.A10;
 
p1_e=double(p1_e); p2=double(p2); p4=double(p4);
p6=double(p6);     p8=double(p8); p10=double(p10);

%奇数次多項式の係数
p1_o=S_odd.A1; p3=S_odd.A3; p5=S_odd.A5;
p7=S_odd.A7;   p9=S_odd.A9; p11=S_odd.A11;

p1_o=double(p1_o); p3=double(p3); p5=double(p5);
p7=double(p7);     p9=double(p9); p11=double(p11);

%%%%多項式の定義(Mathematica)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count=3;

p(1,:)=[0   ,p10 ,0  ,p8 ,0  ,p6 ,0  , p4 , 0  , p2  ,p1_e  ,0]; %偶数フィルタ
p(2,:)=[p11 ,0   ,p9  ,0  ,p7 ,0  ,p5 , 0  , p3 , 0  ,p1_o  ,0]; %奇数フィルタ
p(3,:)=[p11 ,p10 ,p9  ,p8  ,p7 ,p6  ,p5 , p4  , p3 ,p2  ,p1_o  ,0]; %偶数＋奇数フィルタ

%%音声の作成％％％％％％％％％％％％％％％％％％％%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count=3;
new_signal=polyval(p(count,:),X); %歪合成

end
classdef CreateSignal
    %テスト信号の作成
    properties
    fs  %サンプリング周波数
    f   %テスト信号の周波数
    amp %振幅
    end
    
    methods
        %% コンストラクタ
        function param = CreateSignal(sampleRate,freq,amp)
            % Init parameter
            if nargin == 3
                param.fs = sampleRate;
                param.f = freq;
                param.amp = amp;
            else
                error("Input argument need three.")
            end
        end
    
        %% Cos信号の作成
        function [signal,time] = createCosSample(param,period)
        % 余弦波信号を作成する。
        %
        % Args:　
        %    period       : 周期数
        %
        %Return:
        %    signal       : cos振幅データ
        %    time         : 時間データ
        %
        %Note:
        %    ampで始まりampで終わるcos信号を作成する。
        %}
        %====================================================================================                          
            t_end = period/param.f ;
            time = 0 : 1/param.fs : t_end;           
            signal = param.amp*cos(2*pi*param.f*time);

        end

        %% Sin信号の作成
        function [signal,time] = createSinSample(param,period)
        % 正弦波信号を作成する。
        %
        %Args:　
        %    period       : 周期数
        %
        %Return:
        %    signal       : cos振幅データ
        %    time         : 時間データ
        %
        %Note:
        %    0で始まり0で終わるSin信号を作成する。
        %
        %====================================================================================                          
            t_end = period/param.f;
            time = 0 : 1/param.fs : t_end;           
            signal = param.amp*sin(2*pi*param.f*time);
            
        end
        
        %% 高調波の付加
        function new_signal = createDistorionSignal(param,Kd,D2,hnum,signal)
        % 入力に一様減衰の高調波を付加する
        % Args:
        %    Kd          : 2次高調波以降の減衰の傾斜 db/Oct
        %    D2          : 二次高調波の振幅
        %    hnum        : 高調波の次数
        %    data        : 入力データ
        %
        %Returun:
        %    new_signal  : 歪付加後の信号
        %
        %Note:
        %    高調波の振幅値から高調波の係数を逆算し、高調波を付加する多項式モデルを生成する。
        %    THDの定義に従い、振幅1の波形を入力した際の高調波の振幅倍率を仮定している。
        %
        %=======================================================================================
            if hnum > 11
                error("Enter the order of 11 or less.")
            end

            %%高調波のgainの計算
            Amp_c = zeros(1,11);
            Amp_c(1) =1;
            for i=2:hnum
                Amp_c(i)=10^((D2+Kd*log2(i/2))/20); 
            end
        
            %%多項式近似の係数導出
            syms A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11
            
            % 偶数係数
            eqn_even=[A1==Amp_c(1),...
                    1/512*(-210*A10-256*A2-256*A4-240*A6-224*A8)==Amp_c(2),...
                    1/512*(120*A10+64*A4+96*A6+112*A8)==Amp_c(4),...
                    1/512*(-45*A10-16*A6-32*A8)==Amp_c(6),...
                    1/512*(10*A10+4*A8)==Amp_c(8),...
                    -(1/512)*A10==Amp_c(10)];
              
            S_even=solve(eqn_even,[A1,A2,A4,A6,A8,A10]);
            
            % 奇数係数
            eqn_odd=[(1024*A1+462*A11+768*A3+640*A5+560*A7+504*A9)/1024==Amp_c(1),...
                    (-330*A11-256*A3-320*A5-336*A7-336*A9)/1024==Amp_c(3),...
                    (165*A11+64*A5+112*A7+144*A9)/1024==Amp_c(5),...
                    (-55*A11-16*A7-36*A9)/1024==Amp_c(7),...
                    (11*A11+4*A9)/1024==Amp_c(9),...
                    -(A11/1024) ==Amp_c(11)];
            
            S_odd=solve(eqn_odd,[A1,A3,A5,A7,A9,A11]);
            
            % 偶数次多項式の係数
            p1_e=S_even.A1; p2=S_even.A2; p4=S_even.A4;
            p6=S_even.A6;   p8=S_even.A8; p10=S_even.A10;
             
            p1_e=double(p1_e); p2=double(p2); p4=double(p4);
            p6=double(p6);     p8=double(p8); p10=double(p10);
            
            % 奇数次多項式の係数
            p1_o=S_odd.A1; p3=S_odd.A3; p5=S_odd.A5;
            p7=S_odd.A7;   p9=S_odd.A9; p11=S_odd.A11;
            
            p1_o=double(p1_o); p3=double(p3); p5=double(p5);
            p7=double(p7);     p9=double(p9); p11=double(p11);
            
            %%信号生成
            % 係数
            p=[p11 ,p10 ,p9  ,p8  ,p7 ,p6  ,p5 , p4  , p3 ,p2  ,p1_o  ,0]; 
            
            % 合成
            new_signal=polyval(p,signal);
            
        end
% 
%         function [signald,signal] = createDiffangleSignal(Fs,f,k,kd,D2e,D2o,N)
%         %{
%           Create nonlinear distortion with different phases.
%           
%           Synthesize the cosine wave of harmonic components to the base tone
%           Because of the single frequency, intermodulation distortion is not considered
%           
%           Kd=Damping slope[db/oct]　
%           D2=-Amplitude of Second harmonic distortion[dB]
%           N=Number of mac harmonic distortion
%           Fs=sampling frequency
%           k=period
%         %}
%          %===============================================================================
%             
%             kn = floor((Fs/f)*k +1); %Create amount of samples
%             t = (0:kn-1)/Fs;         %Create time samples
%             
%             %% setting amplitude of harmonic distortion
%             i=2;
%             
%             % AMP:Even
%             for n=1:N/2
%             
%             Amp(2*n)=10^((D2e-kd*log2(2*n/2))/20);
%             i=i+1;
%             
%             end
%             
%             % AMP:ODD
%             for n=1:N/2
%             
%             Amp(2*n+1)=10^((D2o-kd*log2((2*n+1)/2))/20);
%             i=i+1;
%             
%             end
%             
%             Amp(1)=1;
%             
%             %% Synthesis
%             
%             % setting angle
%             w=zeros(1,10);
%             w(1,1)=0;
%             rng(1);
%             w(1,2:10)=rand(1,9); %% angle=w*pi
%             
%             % syntesis
%             y=0; i=1; 
%             for i=1:N
%              
%              yn(i,:)=Amp(i)*cos(2*pi*f*i*t+w(i)*pi);
%              y=yn(i,:)+y;
%              
%             end
%             
%             signald=y;       % distorted sample
%             signal=yn(1,:);  % base samle
%             end


% 
    end
end
% 
% 
%         

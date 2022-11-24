function [signald,signal] = make_asyn_distortion_diffangle (Fs,f,k,kd,D2e,D2o,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Create nonlinear distortion with different phases.
%%%
%%%Synthesize the cosine wave of harmonic components to the base tone
%%%Because of the single frequency, intermodulation distortion is not considered
%%%
%%% Kd=Damping slope[db/oct]　
%%% D2=-Amplitude of Second harmonic distortion[dB]
%%% N=Number of mac harmonic distortion
%%% Fs=sampling frequency
%%% k=period
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kn = floor((Fs/f)*k +1); %Create amount of samples
t = (0:kn-1)/Fs;         %Create time samples

%% setting amplitude of harmonic distortion
i=2;

% AMP:Even
for n=1:N/2

Amp(2*n)=10^((D2e-kd*log2(2*n/2))/20);
i=i+1;

end

% AMP:ODD
for n=1:N/2

Amp(2*n+1)=10^((D2o-kd*log2((2*n+1)/2))/20);
i=i+1;

end

Amp(1)=1;

%% Synthesis

% setting angle
w=zeros(1,10);
w(1,1)=0;
rng(1);
w(1,2:10)=rand(1,9); %% angle=w*pi

% syntesis
y=0; i=1; 
for i=1:N
 
 yn(i,:)=Amp(i)*cos(2*pi*f*i*t+w(i)*pi);
 y=yn(i,:)+y;
 
end

signald=y;       % distorted sample
signal=yn(1,:);  % base samle
end
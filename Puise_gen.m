clc; clear; close all;

Fs = 10e3; % Sampling frequency (Hz)
time = 180;
t = 0:1/Fs:time; % Time (sec)

wind = hanning(200001)';
wind2 = hanning(100000)';
win = [zeros(1,300000) wind zeros(1,700000) wind2 zeros(1,500000)]; 

y = 0.5*cos(2*pi*120*t).*win;

load 2500_Fs_10k_Peak
N = filter(Num,Den,randn(1,length(t)));

Target_sig = (1+y).*N;

spectrogram(Target_sig, 1024, 512, 1024, Fs, 'yaixis'); 

load BPF_500_4500_Fs_10k
f_sig = filter(Num,1,Target_sig); clear Num % BPF
square_sig = f_sig.^2; % ^2
load LPF_500_200_Fs_10k
Lf_sig = filter(Num,1,square_sig); clear Num % LPF
DR_sig = detrend(Lf_sig); % Dc removal
DEMON_sig = downsample(DR_sig,10); % Down sampling

figure, spectrogram(DEMON_sig,1024,512,1024,Fs/10,'yaxis');
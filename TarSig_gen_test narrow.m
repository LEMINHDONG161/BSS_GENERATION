% Passive soanr target signal
% Ref) ����ö ��, "����� �����ҳ� �ùķ����� �˰���"
% �ѱ�������ȸ��, 2013

clc; clear; 
close all;
cd('C:\Users\jys\Desktop\BSS and Antenna\Passive sonar\Program_final\SIgnal gen_Program')
Save_Path = 'C:\Users\jys\Desktop\BSS and Antenna\Passive sonar\Program_final\Target_BSS_Program\SaveData';
Prgm_Path = 'C:\Users\jys\Desktop\BSS and Antenna\Passive sonar\Program_final\SIgnal gen_Program';

%% ����
Fs = 10e3; % Sampling frequency (Hz)
time = 180;
t = 0:1/Fs:time; % Time (sec)
Sav = 1; % 0: No save, 1: Save
File_name = ['Target_narrow2']; % Save name

%% ����(����) ����
% <���ڿ� ���� ���� (Ref. H4D, ���������)>
% �, ȭ����, �۾���, ������, ������ �� ���
% ERPM = 2700; % Engine RPM
% Engine_type = 4; % 2: 2����, 4: 4����
% NOC = 4; % �Ǹ��� ����
% NOB = 4; % Blade ���� (�����緯 ����)
% Rg = 2.07; % RPM ���� (�����緯 �� ����ռ� / ���� ũ��ũ �� ����ռ�)

% <��Ʈ ���� (Ref. ��ť�� 8����, ��ť��)>
% ��������� ���� ��Ʈ ���
% ERPM = 5500; % Engine RPM
% Engine_type = 2; % 2: 2����, 4: 4����
% NOC = 2; % �Ǹ��� ����
% NOB = 3; % Blade ���� (�����緯 ����)
% Rg = 2.08; % RPM ���� (�����緯 �� ����ռ� / ���� ũ��ũ �� ����ռ�)

% <��Ʈ ���� (Ref. ��ť�� 150����, ��ť��)>
% ��������� ���� ��Ʈ ���
ERPM = 5800; % Engine RPM
Engine_type = 2; % 2: 2����, 4: 4����
NOC = 3; % �Ǹ��� ����
NOB = 4; % Blade ���� (�����緯 ����)
Rg = 1.92; % RPM ���� (�����緯 �� ����ռ� / ���� ũ��ũ �� ����ռ�)

%% ǥ����ȣ ����
% ��ȣ ���� = [�⺻���ļ� ������1 ������2 ...]
%===== ���� ���� (LOFAR) =====%
Amp_CSR = [3 4]; % Crnk Shaft rate
Amp_CFR = [2 2]; % Cylinder Firing Rate
Amp_ERF = [4]; % Engine Firing Rate

%===== �ܺ� �����緯 (DEMON) =====%
Amp_PSR = [0.42 0.27 0.12 0.1]; % Propeller Shaft Rate
Amp_BR = [0.18]; % Blade Rate
Mod_idx = 0.5; % �������� (���� ���뿪 ��ȣ)

%% �⺻���ļ� ���
f_CSR = ERPM/60; % Crnk Shaft rate
% Cylinder Firing Rate
if Engine_type == 2
    f_CFR = f_CSR;
else if Engine_type == 4
        f_CFR = f_CSR/2;
    end
end
f_ERF = f_CFR*NOC; % Engine Firing Rate
f_PSR = f_CSR/Rg; % Propeller Shaft Rate
f_BR = f_PSR*NOB; % Blade Rate

%% ǥ����ȣ ����
% Crnk Shaft rate
sig_CSR = zeros(size(t));
for i = 1:length(Amp_CSR)
    sig_CSR = sig_CSR+(Amp_CSR(i)*cos(2*pi*i*f_CSR*t));
end
clear i

% Cylinder Firing Rate
sig_CFR = zeros(size(t));
for i = 1:length(Amp_CFR)
    sig_CFR = sig_CFR+(Amp_CFR(i)*cos(2*pi*i*f_CFR*t));
end
clear i

% Engine Firing Rate
sig_ERF = zeros(size(t));
for i = 1:length(Amp_ERF)
    sig_ERF = sig_ERF+(Amp_ERF(i)*cos(2*pi*i*f_ERF*t));
end
clear i

% Propeller Shaft Rate
sig_PSR = zeros(size(t));
for i = 1:length(Amp_PSR)
    sig_PSR = sig_PSR+(Amp_PSR(i)*cos(2*pi*i*f_PSR*t));
end
clear i

% Blade Rate
sig_BR = zeros(size(t));
for i = 1:length(Amp_BR)
    sig_BR = sig_BR+(Amp_BR(i)*cos(2*pi*i*f_BR*t));
end
clear i


   
   
   
% ���� ���뿪 ��ȣ
S_un = sig_CSR + sig_CFR + sig_ERF + sig_PSR +sig_BR;

% ���� ���뿪 ��ȣ
S_mn = S_un.*cos(2*pi*f_BR*t);

% ���� ���뿪 ��ȣ
load 2500_Fs_10k_Peak
S_ub = max([detrend(sig_PSR) detrend(sig_BR)])...
    *(1/Mod_idx)*filter(Num,Den,randn(1,length(t)));
% Transient Signal
sig_TS = zeros(size(t));
sig_TS =  sig_TS + 20*cos(2*pi*300*t).*(sin(2*pi*1/40*t + pi/2).*heaviside(t-30).*heaviside(50-t)+sin(2*pi*1/20*t).*heaviside(t-120).*heaviside(130-t));


 
 
    

% ���� ���뿪 ��ȣ
S_mb = ((1+(sig_PSR+sig_BR)).*S_ub);

% ǥ�� ��ȣ
Target_sig = S_un;

%% Save
if Sav > 0
    cd(Save_Path)
    save(File_name, 'Target_sig');
    cd(Prgm_Path)
end
%% Figure
 figure, spectrogram(Target_sig,2^12,512,1024*2,Fs,'yaxis');

 [S_T,F_T,T_T,P_T] = spectrogram(Target_sig,2^12,512,1024*30,Fs,'yaxis');
 
figure,
plot(F_T,P_T(:,2)/max(P_T(:,2)))
 xlabel('Frequency (Hz) target172507_2','fontsize',12); ylabel('Normalized spectrum','fontsize',12);
 set(gca,'fontsize',12)
 set(gcf,'color','w')
 grid on
 xlim([0 500])
 
%% DEMON analysis
load BPF_500_4500_Fs_10k
f_sig = filter(Num,1,Target_sig); clear Num % BPF
square_sig = f_sig.^2; % ^2
load LPF_500_200_Fs_10k
Lf_sig = filter(Num,1,square_sig); clear Num % LPF
DR_sig = detrend(Lf_sig); % Dc removal
DEMON_sig = downsample(DR_sig,10); % Down sampling

figure, spectrogram(DEMON_sig,512,256,1024,Fs/10,'yaxis');

[S,F,T,P] = spectrogram(DEMON_sig,512,256,1024,Fs/10,'yaxis');

figure,
plot(F,P(:,2)/max(P(:,2)))
xlabel('Frequency (Hz)','fontsize',12); ylabel('Normalized spectrum','fontsize',12);
set(gca,'fontsize',12)
set(gcf,'color','w')
grid on
% 
% Y = fft(DEMON_sig);
% L = length(DEMON_sig);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = (Fs/10)*(0:(L/2))/L;
% 
% figure,
% plot(f,P1/max(P1))
% xlabel('Frequency (Hz)', 'fontsize', 12)
% ylabel('Normalized spectrum','fontsize',12);
% set(gca,'fontsize',12)
% set(gcf,'color','w')
% xlim([0 300])
% grid on

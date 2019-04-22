function Fig_DEMON(DeFig_sel, Fs, DEMON_sig, win, overlap, nfft, Caxs, Ylm)

if DeFig_sel > 0
figure,
set(gcf,'numbertitle','off','name', 'DEMON �м� ��ȣ (�����緯 ��ȣ ����)');
[S,F,T,P] = spectrogram(DEMON_sig,win,overlap,nfft,Fs);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight;
view(0,90);
colorbar;
caxis(Caxs)
ylim(Ylm)
xlabel('Time (Sec)','fontsize',12); ylabel('Frequency (Hz)','fontsize',12);
set(gca,'fontsize',12)
set(gcf,'color','w')
end

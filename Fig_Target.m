function Fig_Target(TarFig_sel, Fs, Num_target, Target_sig,...
    MT_sig, win, overlap, nfft, Caxs, Ylm)

figure,
set(gcf,'numbertitle','off','name', '단일표적신호');
for i = 1:Num_target
    subplot(Num_target,1,i)
    [S,F,T,P] = spectrogram(Target_sig(i,:),win,overlap,nfft,Fs);
    surf(T,F,10*log10(P),'edgecolor','none'); axis tight;
    view(0,90);
    colorbar;
    caxis(Caxs)
    ylim(Ylm)
    xlabel('Time (Sec)','fontsize',12); ylabel('Frequency (Hz)','fontsize',12);
    set(gca,'fontsize',12)
    set(gcf,'color','w')
end
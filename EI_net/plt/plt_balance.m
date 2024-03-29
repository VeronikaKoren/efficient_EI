

close all
clear all

savefig1=0;
savefig2=0;

figname1='dist_mean_currents';
figname2='rho_0net';

addpath('/Users/vkoren/ei_net/result/balance/');
loadname='balance_0net';
load(loadname);

%%
a=0.3;
I_exc=I_exc.*a; % with units
I_inh=I_inh.*a;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
green=[0.2,0.7,0];
col={'k',blue,green;red,blue,green};

fs=14;
ms=6;
lw=1.2;
lwa=1;

pos_vec=[0,0,14,6];
savefile='/Users/vkoren/ei_net/figure/statistics_0net/';

namepop={'ff','Inh','net E';'Exc','Inh','net I'};

xt=0:2:2;
mini=min(cat(1,I_exc(:),I_inh(:)));
maxi=max(cat(1,I_exc(:),I_inh(:)));
xi=linspace(mini-0.5,maxi+0.5,200);

%%

H1=figure('name',figname1);
for k=1:2
    
    if k==1
        y=I_exc;
    else
        y=I_inh;
    end
        
    rec=sum(y,2);
    
    f1=ksdensity(y(:,1),xi);
    f2=ksdensity(y(:,2),xi);
    frec=ksdensity(rec,xi);
    
    subplot(1,2,k)
    plot(xi,f1,'color',col{k,1},'linewidth',lw)
    hold on
    plot(xi,f2,'color',col{k,2},'linewidth',lw)
    if k==1
        plot(xi,frec,':','color',col{k,3},'linewidth',lw)
    else
        plot(xi,frec,'color',col{k,3},'linewidth',lw)
    end
    hold off
    box off

    for ii=1:3
        text(0.05,0.9-(ii-1)*0.13,namepop{k,ii},'units','normalized','fontsize',fs,'color',col{k,ii})
    end

    %ylim([0,8])
    %xlim([-5,5])
    if k==3
        ylabel('probability density','Fontsize',fs)
    end
    %xlabel('current [mV]','Fontsize',fs)

    set(gca,'XTick',xt);
    set(gca,'XTickLabel',xt,'Fontsize',fs)
    set(gca,'YTick',[]);
    %set(gca,'YTickLabel',[])

    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out');

    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.00 op(2)+0.09 op(3)+0.02 op(4)-0.04]);
end

axes
h1 = ylabel ('density','units','normalized','Position',[-0.08,0.53,0],'fontsize',fs+1);
h2 = xlabel ('synaptic input [mV]','units','normalized','Position',[0.5,0.0,0],'fontsize',fs);
%h2 = xlabel ('mean current [mV]','units','normalized','Position',[0.5,-0.02,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H1, 'Units','centimeters', 'Position', pos_vec)
set(H1,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig1==1
    print(H1,[savefile,figname1],'-dpng','-r300');
end
%% 1 plot distribution of correlation coefficients


yt=0:0.2:0.2;
gray=[0.2,0.2,0.2];
xt=0.25:0.1:0.45;

rho=cell(2,1);
rho{1}=abs(rho_e);
rho{2}=abs(rho_i);

%%
pos_vec=[0,0,14,7];
H2=figure('name',figname2);
hold on
for k=1:2
    
    y=rho{k};
    meanr=mean(y);
    mr=round(y*10)/10;
  
    histogram(y,8,'FaceColor',col{2,k},'Normalization','probability')

    plot(meanr,0.28,'v','MarkerFaceColor',col{2,k},'MarkerEdgeColor','k')
    text(meanr-0.028,0.31,['$\rho=$ ' sprintf('%0.2f',meanr)],'Fontsize',fs,'Interpreter','latex')
    
end
text(0.25,0.7,'in I neurons: \rho(A^{IE}(t),A^{II}(t))','units','normalized','color',blue,'Fontsize',fs)
text(0.25,0.45,'in E neurons: \rho(A^{ff}(t),A^{EI}(t))','units','normalized','color',red,'Fontsize',fs)

box off

ylim([0,0.33])
xlim([0.21,0.48])
ylabel('fraction neurons','Fontsize',fs)
xlabel('correlation of synaptic inputs','Fontsize',fs)

set(gca,'XTick',xt);
set(gca,'XTickLabel',xt,'Fontsize',fs)
set(gca,'YTick',yt);
set(gca,'YTickLabel',yt,'Fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out');

set(H2, 'Units','centimeters', 'Position', pos_vec)
set(H2,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)])

if savefig2==1
    print(H2,[savefile,figname2],'-dpng','-r300');
end
%}

%% rho density
%{ 
[f,xi]=ksdensity(r_dist);

meanr=nanmean(r_dist);
mr=round(meanr*10)/10;
delta=max(f)*0.1;
maxi=max(f);

yt=30:30:60;
xt=-0.48:0.04:-0.4;

%%

H2=figure('name',figname2);
plot(xi,f,'color','k')
hold on
plot(meanr,maxi+delta,'v','MarkerFaceColor','r')
hold off
box off

text(meanr-0.02,maxi+2*delta,['mean = ' sprintf('%0.2f',meanr)],'Fontsize',fs)
ylim([0,maxi+3*delta])
xlim([-0.48,-0.4])
ylabel('probability density','Fontsize',fs)
xlabel('corr. of E and I currents','Fontsize',fs)

set(gca,'XTick',xt);
set(gca,'XTickLabel',xt,'Fontsize',fs)
set(gca,'YTick',yt);
set(gca,'YTickLabel',yt,'Fontsize',fs)

set(H2, 'Units','centimeters', 'Position', pos_vec)
set(H2,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H2,[savefile,figname2],'-dpng','-r300');
end
%}
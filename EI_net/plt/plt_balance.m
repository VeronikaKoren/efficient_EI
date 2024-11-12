

close all
clear all

savefig1=0;
savefig2=0;
figname1='rho_0net';
figname2='dist_mean_currents';

%addpath('/Users/vkoren/ei_net/result/balance/');
addpath('/Users/vkoren/ei_net/result/implementation/');
loadname='activity_measures_distribution';
load(loadname,'re_tr','ri_tr','Ie_tr','Ii_tr');

%%

ntr=size(Ie_tr,1);
Ae=reshape(Ie_tr,ntr*size(Ie_tr,2),2);
Ai=reshape(Ii_tr,ntr*size(Ii_tr,2),2);

display(mean(sum(Ae,2)),'average net current in E')
display(mean(sum(Ai,2)),'average net current in I')
%%

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
green=[0.2,0.7,0];
col={'k',blue,green;red,blue,green};

fs=15;
ms=6;
lw=1.2;
lwa=1;

pos_vec=[0,0,12,6];
savefile='/Users/vkoren/ei_net/figure/statistics_0net/';

%% plot distribution of correlation coefficients

yt=0:0.2:0.2;
gray=[0.2,0.2,0.2];
xt=0.25:0.1:0.45;

rho=cell(2,1);
rho{1}=abs(re_tr(:));
rho{2}=abs(ri_tr(:));
%rho{1}=rho_e;
%rho{2}=rho_i;
ym=[0.28,0.4];
%%

H=figure('name',figname1);
hold on
for k=1:2
    
    y=rho{k};
    meanr=mean(y);
    mr=round(y*10)/10;
  
    histogram(y,'FaceColor',col{2,k},'Normalization','probability')

    plot(meanr,ym(k),'v','MarkerFaceColor',col{2,k},'MarkerEdgeColor','k')
    text(meanr-0.02,0.45,['$\bar{\rho}=$ ' sprintf('%0.2f',meanr)],'Fontsize',fs,'Interpreter','latex')
    
end
text(0.2,0.7,'in I neurons: \rho(A^{IE}(t),A^{II}(t))','units','normalized','color',blue,'Fontsize',fs)
text(0.2,0.52,'in E neurons: \rho(A^{ff}(t),A^{EI}(t))','units','normalized','color',red,'Fontsize',fs)

box off

ylim([0,0.5])
%xlim([-0.48,-0.22])
ylabel('fraction neurons','Fontsize',fs)
xlabel('correlation of synaptic inputs','Fontsize',fs)

set(gca,'XTick',xt);
set(gca,'XTickLabel',xt,'Fontsize',fs)
set(gca,'YTick',yt);
set(gca,'YTickLabel',yt,'Fontsize',fs)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out');

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)])

if savefig1==1
    print(H,[savefile,figname1],'-dpng','-r300');
end


%% plot distribution of E, I and rec current

nameA={'ff','Inh','net';'Exc','Inh','net'};
yt=5;
xt=-4:4:4;
mini=min(cat(1,Ae(:),Ai(:)));
maxi=max(cat(1,Ae(:),Ai(:)));
xi=linspace(mini-0.5,maxi+0.5,200);

H=figure('name',figname2);
for k=1:2
    
    if k==1
        y=Ae;
    else
        y=Ai;
    end
        
    net=sum(y,2);
    
    f1=ksdensity(y(:,1),xi);
    f2=ksdensity(y(:,2),xi);
    frec=ksdensity(net,xi);
    
    subplot(1,2,k)
    plot(xi,f1,'color',col{k,1},'linewidth',lw)
    hold on
    plot(xi,f2,'color',col{k,2},'linewidth',lw)
    if k==1
        plot(xi,frec,':','color',col{k,3},'linewidth',lw)
    else
        plot(xi,frec,'color',col{k,3},'linewidth',lw)
    end
    %plot(xi,frec,'color',col{k,3},'linewidth',lw)
    hold off
    box off

    for ii=1:3
        text(0.1,0.9-(ii-1)*0.12,nameA{k,ii},'units','normalized','fontsize',fs,'color',col{k,ii})
    end

    ylim([0,10])
    xlim([-5,5])
    if k==3
        ylabel('probability density','Fontsize',fs)
    end
    %xlabel('current [mV]','Fontsize',fs)

    set(gca,'XTick',xt);
    set(gca,'XTickLabel',xt,'Fontsize',fs)
    set(gca,'YTick',yt);
    set(gca,'YTickLabel',yt,'Fontsize',fs)

    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out');

    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.1 op(3)-0.0 op(4)-0.04]);
end

axes
h1 = ylabel ('density','units','normalized','Position',[-0.08,0.5,0],'fontsize',fs);
h2 = xlabel ('synaptic input [mV]','units','normalized','Position',[0.5,0.0,0],'fontsize',fs);
%h2 = xlabel ('RI^{syn} [mV]','units','normalized','Position',[0.5,0.0,0],'fontsize',fs);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end
%}


close all
clear all
clc

savefig=0;
figname='dist_frate_0net';

addpath('/Users/vkoren/ei_net/result/statistics/frate/')
savefile=[cd,'/figure/implementation/'];

N=1500;

loadname=['mean_fr_N',sprintf('%1.0i',N)];       % get spikes
load(loadname);

fr=cell(2,1);
fr{1}=ze;
fr{2}=zi;
%%

fs=13;
ms=7;
lw=1.7;
lwa=1;
pos_vec=[0,0,8,9];

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];

col={red,blue};

xt=0:5:20;
yt=0:0.2:0.2;
namep={'Exc','Inh'};

%%

H=figure('name',figname);
for c=1:2
    
    y=fr{c};
    idx0=find(y==0);
    y(idx0)=[];
    n=numel(y);
    pHat = lognfit(y+0.5);
    xvec=linspace(min(y),max(y));
    g=pdf('LogNormal',xvec,pHat(1),pHat(2));
    
    subplot(2,1,c)
    hold on
    histogram(y,'BinLimits',[min(y),max(y)],'BinMethod','integers','normalization','probability','FaceColor',col{c})
    
    plot(xvec,g,'color','k')
    text(0.75,0.8,namep{c},'units','normalized','color',col{c},'fontsize',fs)
    text(0.6,0.65,'log-normal','units','normalized','color','k','fontsize',fs)
    
    axis([0,23,0,0.2])
    box off
    
    set(gca,'XTick',xt)
    if c==1
        set(gca,'XTicklabel',[])
    else
        set(gca,'XTicklabel',xt,'fontsize',fs)
    end
    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out');
    
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.03 op(3)-0.07 op(4)-0.03]);
end


set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h1 = ylabel ('fraction of neurons','units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
h2 = xlabel ('firing rate','units','normalized','Position',[0.5,-0.06,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%% plots the distribution of firing rates and of coefficients of variation across neurons
% in the optimal network

close all
clear
clc

savefig=[0,0];
figname1='dist_frate_0net';
figname2='cv_0net';

%%

savefile=pwd;

addpath([cd,'/result/EI_net/']);
loadname='activity_measures_distribution';
load(loadname,'fre_tr','fri_tr','CVe_tr','CVi_tr');

%%

fr=cell(2,1);
fr{1}=fre_tr(:);
fr{2}=fri_tr(:);

cvs=cell(2,1);
cvs{1}=CVe_tr(:);
cvs{2}=CVi_tr(:);
%%

display(cellfun(@mean,fr),'average firing rate E and I');
display(cellfun(@mean,cvs),'average CV E and I');
%%

fs=13;
ms=7;
lw=1.4;
lwa=1;
pos_vec=[0,0,8,9];

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];

col={red,blue};

namep={'Exc','Inh'};

xt={6:2:10,5:10:25};
yt={0:0.3:0.3,0:0.1:0.1};
ax={[5,12,0,0.5],[4,25,0,0.15]};

%%

H=figure('name',figname1);
for c=1:2
    
    y=fr{c};
    idx0=find(y==0);

    n=numel(y);
    pHat = lognfit(y);
    xvec=linspace(min(y)-2,max(y)+0.5);
    g=pdf('LogNormal',xvec,pHat(1),pHat(2));
    
    subplot(2,1,c)
    hold on
    histogram(y,'BinMethod','fd','normalization','pdf','FaceColor',col{c})
   
    plot(xvec,g,'color','k','linewidth',lw)
    text(0.72,0.8,namep{c},'units','normalized','color',col{c},'fontsize',fs)
    text(0.62,0.65,'log-normal','units','normalized','color','k','fontsize',fs)
    
    axis(ax{c})
    set(gca,'YTick',yt{c})
    set(gca,'YTicklabel',yt{c},'fontsize',fs)
    set(gca,'XTick',xt{c})
    set(gca,'XTicklabel',xt{c},'fontsize',fs)
    box off
    
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out');
    
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.07 op(2)+0.03 op(3)-0.07 op(4)-0.03]);
end


set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h1 = ylabel ('probability density','units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
h2 = xlabel ('firing rate [Hz]','units','normalized','Position',[0.5,-0.04,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

if savefig(1)==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% CV

xt=[0.8,1,1.2];
yt=[0,6];

H=figure('name',figname2);
for c=1:2
    
    y=cvs{c};
    
    subplot(2,1,c)
    hold on
    
    histogram(y,'BinMethod','fd','normalization','pdf','FaceColor',col{c})
    %histogram(y,'BinWidth',0.05,'normalization','probability','FaceColor',col{c})
    
    text(0.75,0.8,namep{c},'units','normalized','color',col{c},'fontsize',fs)
    
    axis([0.75,1.25,0,12])
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
h1 = ylabel ('probability density','units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
h2 = xlabel ('coefficient of variation','units','normalized','Position',[0.5,-0.06,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

if savefig(2)==1
    print(H,[savefile,figname2],'-dpng','-r300');
end
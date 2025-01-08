%% plots measures of performance and dynamics for networks with and without connectivity structure

close all
clear
clc

savefig=[0,0,0,0,0];
ctype=2;  % 2 for fully permuted, 3 for partially permuted

namet={'structured','perm_full_all','perm_partial_all'};
namef={'','fully_permuted','partially_permuted'};

figname1=['error_regular_',namet{ctype}];
figname2=['cost_regular_',namet{ctype}];
figname3=['net_regular_',namet{ctype}];
figname4=['r_regular_',namet{ctype}];
figname5=['fr_regular_',namet{ctype}];

addpath([cd,'/result/structure/'])
savefile=pwd;

ntr=200;
rmse=zeros(ntr,2,2);
mc=zeros(ntr,2,2);
net=zeros(ntr,2,2);
r=zeros(ntr,2,2);
fr=zeros(ntr,2,2);
CV=zeros(ntr,2,2);

for k=1:2
    if k==1
        loadname='measures_matching_average_structured';
    else
        loadname=['measures_trials_',namet{ctype}];
    end
    load(loadname,'kappa_tr','net_tr','fr_tr','r_tr','CV_tr','rmse_tr');

    rmse(:,k,:)=rmse_tr;
    mc(:,k,:)=kappa_tr;
    
    net(:,k,:)=net_tr;
    r(:,k,:)=abs(r_tr);

    fr(:,k,:)=fr_tr;
    CV(:,k,:)=CV_tr;

end

%% fig. stuff

tit={'in Excitatory','in Inhibitory'};
measures={'RMSE','metabolic cost','net synaptic input [mV]',...
    'correlation coefficient','firing rate [Hz]','coefficient of variation'};
ntr=size(fr,1);

pos_vec=[0,0,8,12];
fs=15;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};
lwa=1;

namex={'structured','shuffled'};
xt=[1,2];

%% error

yt=[5,15];
ylimit=[0,30];
H=figure('name',figname1,'Position',pos_vec);
for k=1:2
    subplot(2,1,k)
    h=boxplot(squeeze(rmse(:,:,k)),'symbol','.','MedianStyle','target','color','k');
    box off
    set(h,{'linew'},{1.5})

    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    set(gca,'XTick',xt)
    if k==1
        set(gca,'XTickLabel',[])
    else
        set(gca,'XTickLabel',namex,'fontsize',fs)
    end
    
    title(tit{k},'fontsize',fs)
    ylim(ylimit)

    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.0 op(3)-0.05 op(4)+0.02]);
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out')

end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h2 = ylabel (measures{1},'units','normalized','Position',[-0.06,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

if savefig(1)==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% cost

yt=[3,7];
ylimit=[2,8];

H=figure('name',figname2,'Position',pos_vec);
for k=1:2
    subplot(2,1,k)
    h=boxplot(squeeze(mc(:,:,k)),'symbol','.','MedianStyle','target','color','k');
    box off
    set(h,{'linew'},{1.5})
    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    set(gca,'XTick',xt)
    if k==1
        set(gca,'XTickLabel',[])
    else
        set(gca,'XTickLabel',namex,'fontsize',fs)
    end
    
    title(tit{k},'fontsize',fs)
    ylim(ylimit)
    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.0 op(3)-0.05 op(4)+0.02]);
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out')

end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h2 = ylabel (measures{2},'units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

if savefig(2)==1
    print(H,[savefile,figname2],'-dpng','-r300');
end
%}
%% average balance

yt=[-1.5,-0.5];
ylimit=[-1.8,-0.2];

H=figure('name',figname3,'Position',pos_vec);
for k=1:2
    subplot(2,1,k)
    h=boxplot(squeeze(net(:,:,k)),'symbol','.','MedianStyle','target','color','k');
    set(h,{'linew'},{1.5})
    box off

    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    set(gca,'XTick',xt)
    if k==1
        set(gca,'XTickLabel',[])
    else
        set(gca,'XTickLabel',namex,'fontsize',fs)
    end
    
    title(tit{k},'fontsize',fs)
    ylim(ylimit)

    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.08 op(2)+0.0 op(3)-0.05 op(4)+0.02]);
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
   
end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h2 = ylabel (measures{3},'units','normalized','Position',[-0.06,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

if savefig(3)==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%% instantaneous balance

ylimit=[-0.05,0.55];
yt=[0,0.3];

H=figure('name',figname4,'Position',pos_vec);
for k=1:2
    subplot(2,1,k)
    h=boxplot(squeeze(r(:,:,k)),'symbol','g','MedianStyle','target','color','k');
    set(h,{'linew'},{1.5})
    box off

    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    ylim(ylimit)
    set(gca,'XTick',xt)
    if k==1
        set(gca,'XTickLabel',[])
    else
        set(gca,'XTickLabel',namex,'fontsize',fs)
    end
    
    title(tit{k},'fontsize',fs)

    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.0 op(3)-0.05 op(4)+0.02]);
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);

end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h2 = ylabel(measures{4},'units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

if savefig(4)==1
    print(H,[savefile,figname4],'-dpng','-r300');
end

%% firing rate

ylimit=[5,25];
yt=[10,20];

H=figure('name',figname5,'Position',pos_vec);
for k=1:2
    subplot(2,1,k)
    h=boxplot(squeeze(fr(:,:,k)),'symbol','g.','MedianStyle','target','color','k');
    box off
    set(h,{'linew'},{1.5})
    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt,'fontsize',fs)
    ylim(ylimit)
    set(gca,'XTick',xt)
    if k==1
        set(gca,'XTickLabel',[])
    else
        set(gca,'XTickLabel',namex,'fontsize',fs)
    end
    
    title(tit{k},'fontsize',fs)

    op=get(gca,'OuterPosition');
    set(gca,'OuterPosition',[op(1)+0.06 op(2)+0.0 op(3)-0.05 op(4)+0.02]);
    set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
    set(gca,'TickDir','out')

end

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h2 = ylabel(measures{5},'units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

if savefig(5)==1
    print(H,[savefile,figname5],'-dpng','-r300');
end


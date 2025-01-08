%% plots coefficient of variation for networks with and without connectivity structure
%% using a constant sitmulus

close all
clear
clc

savefig=0;
ctype=2;

namet={'structured','perm_full_all'};
figname=['CV_const_',namet{ctype}];

addpath([cd,'/result/structure/']);
savefile=pwd;

ntr=200;
CV=zeros(ntr,2,2);

for k=1:2
    if k==1
        loadname=['measures_matching_average_',namet{k}];
    else
        loadname=['measures_trials_constant_',namet{k}];
    end
    load(loadname,'CV_tr');
    CV(:,k,:)=CV_tr;

end

%% fig. stuff

tit={'in Excitatory','in Inhibitory'};
measures={'coefficient of variation (constant stim.)'};
ntr=size(CV,1);

pos_vec=[0,0,8,12];
fs=14;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};
lwa=1;

namex={'structured','shuffled'};
xt=[1,2];



%% CV
ylimit=[0.5,1.5];
yt=[0.8,1.2];

H=figure('name',figname,'Position',pos_vec);
for k=1:2
    subplot(2,1,k)
    boxplot(squeeze(CV(:,:,k)),'symbol','g.','MedianStyle','target')
    box off

    set(gca,'YTick',yt)
    set(gca,'YTicklabel',yt)
    ylim(ylimit)
    set(gca,'XTick',xt)
    if k==1
        set(gca,'XTickLabel',[])
    else
        set(gca,'XTickLabel',namex)
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
h2 = ylabel(measures{1},'units','normalized','Position',[-0.08,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

if savefig(1)==1
    print(H,[savefile,figname],'-dpng','-r300');
end
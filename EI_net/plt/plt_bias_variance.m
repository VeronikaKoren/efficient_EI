
close all
clear all
%clc

savefig=[0,1];
ntype={'min_error','min_loss'};
type=2;

%%
addpath('/Users/vkoren/ei_net/result/statistics/bias/')
loadname=['bias_var_',ntype{type}];       
load(loadname);

By=cellfun(@mean, Bploty);
display(By,'average bias of estimators E and I')

%Vy=cellfun(@mean, Vploty);
%display(Vy,'average variance of estimators E and I')
%[hE,pE]=ttest(Bploty{1})
%[hI,pI]=ttest(Bploty{2})
%%
savefile='/Users/vkoren/ei_net/figure/statistics_0net/';
addpath([cd,'/result/statistics/bias/'])

figname=['signal_bias_',ntype{type}];
figname2=['boxplot_bias_',ntype{type}];
%%

fs=14;
ms=7;
lw=1.4;
lwa=1;
%pos_vec=[0,0,8,9];

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
green=[0.2,0.7,0.1,0.8];

col={'k',red};
coli={red,blue};
coldim={'k',[0.5,0.5,0.5],green};

namep={'Exc','Inh'};
xt=[0,500,1000];
M=parameters{2}{:};

%%
pos_vec=[0,0,10,8];
yt=[-7,0,7];

H=figure('Position', pos_vec,'name',figname2);

boxplot(cell2mat(Bploty'),namep,'symbol','g.','MedianStyle','target')
hl=line([0,3],[0,0],'color',[0.7,0.7,0.7],'LineStyle','--','LineWidth',1.5);
box off
ylabel('bias estimate','fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)

set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

if savefig(2)==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

%%

nve={'target','E estimate'};
nvi={'target','I estimate'};
styles={'-','--'};

xl=[0,1000];
pos_vec=[0,0,22,10];

yt=[-40,0,40];
H=figure('name',figname);
subplot(2,2,1)
hold on
for ii=1:2
    plot(tidx,sigE{ii},'color',col{ii},'linestyle',styles{ii})
    text(0.1+(ii-1)*0.25,0.1,nve{ii},'color',col{ii},'units','normalized','fontsize',fs)
end
hold off
title('signal (dim = 1)')
ylim([-50,50])
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylabel('E neurons')
xlim(xl)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.02 op(3)-0.0 op(4)-0.0]);


yt=[-10,0,10];
subplot(2,2,2)
hold on
for ii=1:M
    plot(tidx,Bky{1}(ii,:),'color',coldim{ii})
    text(0.03+(ii-1)*0.25,0.9,['dim = ',sprintf('%1.0i',ii)],'units','normalized','color',coldim{ii},'fontsize',fs)
end
hold off
title('bias')
xlim(xl)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylim([-15,15])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.02 op(3)-0.0 op(4)-0.00]);

yt=[-40,0,40];
subplot(2,2,3)
hold on
hold on
for ii=1:2
    plot(tidx,sigI{ii},'color',coli{ii},'linestyle',styles{ii})
    text(0.1+(ii-1)*0.25,0.1,nvi{ii},'color',coli{ii},'units','normalized','fontsize',fs)
end
hold off

ylabel('I neurons')
xlim(xl)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylim([-50,50])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.02 op(3)-0.0 op(4)-0.00]);

yt=[-4,0,4];
subplot(2,2,4)
hold on
for ii=1:M
    plot(tidx,Bky{2}(ii,:),'color',coldim{ii})
end
hold off
xlim(xl)
set(gca,'XTick',xt)
set(gca,'XTicklabel',xt,'fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
ylim([-5,5])

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.02 op(3)-0.0 op(4)-0.00]);


set(H, 'Units','centimeters', 'Position', pos_vec)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[pos_vec(3), pos_vec(4)]) % for saving in the right size

axes
h2 = xlabel ('time [ms]','units','normalized','Position',[0.5,-0.06,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')

if savefig(1)==1
    print(H,[savefile,figname],'-dpng','-r300');
end



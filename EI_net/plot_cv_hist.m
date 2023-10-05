
clear all
close all

savefig=0;
figname='cv_0net';

addpath('/Users/vkoren/ei_net/result/statistics/cv/')
savefile=[cd,'/figure/implementation/'];

loadname='cv_0net';
load(loadname)

%% mean across neurons


cvs=cell(2,1);
cvs{1}=cv_E;
cvs{2}=cv_I;

display(cellfun(@mean,cvs),'cv_E,cv_I')

%%
fs=13;
ms=7;
lw=1.7;
lwa=1;
pos_vec=[0,0,8,9];

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};

namep={'Exc','Inh'};
xt=0:0.5:1.5;
yt=0:0.2:0.2;
%%

H=figure('name',figname);
for c=1:2
    
    y=cvs{c};
    
    subplot(2,1,c)
    hold on
    histogram(y,25,'BinWidth',0.05,'normalization','probability','FaceColor',col{c})
    
    text(0.75,0.8,namep{c},'units','normalized','color',col{c},'fontsize',fs)
    
    axis([0.5,1.5,0,0.23])
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
h2 = xlabel ('coefficient of variation','units','normalized','Position',[0.5,-0.06,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h1,'visible','on')
set(h2,'visible','on')

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%%

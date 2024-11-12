
clear all
close all

savefig=0;

k=2;
namet={'perm_full','perm_partial'};

figname=['CVs_',namet{k}];
savefile=['/Users/vkoren/ei_net/figure/weights_J/effect_structure/',namet{k},'/'];

disp(['plotting ' ,figname,'and optimal'])

%% load result with unstructured

addpath('/Users/vkoren/ei_net/result/connectivity/')
loadname=['measures_',namet{k}];
load(loadname,'CVs','which_permuted')
CV=CVs;
clear CVs
np=length(which_permuted);

%% load result optimal network

addpath('/Users/vkoren/ei_net/result/implementation/')
loadname='activity_measures_optimal_ei';
load(loadname,'CV_tr')
CV0=mean(CV_tr);

%%

fs=13;
ms=8;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};

plt1=[0,0,8,11];

xvec=1:np;
xt=xvec;
xlb=which_permuted;
yt=0.7:0.3:1.3;

xlimit=[0.3,4.7];
namep={'in Exc','in Inh'};
which_permuted{4}(4:end)=[];

order=[2,1,3,4];
Co=which_permuted(order);
nametit={'fully unstructured','partially unstructured'};
%%

H=figure('name',figname);
subplot(2,1,1)
plot(CV(order,1),'d','color','k','markersize',ms,'MarkerFaceColor','r');

line([0.5 4.5],[CV0(1) CV0(1)],'Color',col{1},'LineStyle','--')
text(0.05,0.9,namep{1},'units','normalized','fontsize',fs,'color',col{1})
box off

xlim(xlimit)
ylim([0.5,1.3])

text(0.2,1.1,nametit{k},'units',' normalized','fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
xtickangle(25)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.05 op(3)-0.05 op(4)-0.03]);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

%%% I neurons

subplot(2,1,2)
hold on
plot(CV(order,2),'d','color','k','markersize',ms,'MarkerFaceColor',col{2});

line([0.5 4.5],[CV0(2) CV0(2)],'Color',col{2},'LineStyle','--')
text(0.05,0.9,namep{2},'units','normalized','fontsize',fs,'color',col{2})

hold off
box off

xlim(xlimit)
ylim([0.5, 1.3])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt)
set(gca,'XTick',xt)
set(gca,'XTicklabel',Co)
xtickangle(25)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.05 op(3)-0.05 op(4)+0.0]);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes

h2 = ylabel ('coefficient of variation','units','normalized','Position',[-0.08,0.5,0]);
set(gca,'Visible','off')
set(h2,'visible','on')


set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%

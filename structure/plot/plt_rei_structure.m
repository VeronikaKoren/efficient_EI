
clear all
close all

savefig=0;

k=1;
namet={'perm_full','perm_partial'};

figname=['r_ei_',namet{k}];
savefile=['/Users/vkoren/ei_net/figure/weights_J/effect_structure/',namet{k},'/'];

disp(['plotting ' ,figname])

%% load results

addpath('/Users/vkoren/ei_net/result/connectivity/')
loadname=['measures_',namet{k}];
load(loadname,'r_ei','Ct')
t_balance=abs(r_ei);
clear r_ei

loadname='Cnoise_factor_measures'; % baseline (regular network)
load(loadname,'r_ei')

r0=abs(r_ei(1,:));

%%

fs=13;
ms=8;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
col={red,blue};

plt1=[0,0,8,11];

xvec=1:4;
xt=1:4;
xlb=Ct;
yt=0:0.2:0.4;

xlimit=[0.3,4.7];
namep={'in Exc','in Inh'};
Ct{4}(4:end)=[];

order=[2,1,3,4];
Co=Ct(order);

%%

H=figure('name',figname);
subplot(2,1,1)
plot(t_balance(order,1),'d','color','k','markersize',ms,'MarkerFaceColor','r');

line([0.5 4.5],[r0(1) r0(1)],'Color',col{1},'LineStyle','--')
text(0.05,0.9,namep{1},'units','normalized','fontsize',fs,'color',col{1})
box off

xlim(xlimit)
ylim([-0.1,0.55])
title('instantaneous balance')

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',[])
xtickangle(25)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.0 op(3)-0.05 op(4)-0.01]);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')


%%% I neurons

subplot(2,1,2)
hold on
plot(t_balance(order,2),'d','color','k','markersize',ms,'MarkerFaceColor',col{2});

line([0.5 4.5],[r0(2) r0(2)],'Color',col{2},'LineStyle','--')
text(0.05,0.9,namep{2},'units','normalized','fontsize',fs,'color',col{2})

hold off
box off

xlim(xlimit)
ylim([-0.1,0.55])

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',xt)
set(gca,'XTicklabel',Co)
xtickangle(25)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.05 op(2)+0.0 op(3)-0.05 op(4)+0.01]);
set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

axes

h2 = ylabel ('correlation coefficient','units','normalized','Position',[-0.09,0.5,0],'fontsize',fs+1);
set(gca,'Visible','off')
set(h2,'visible','on')


set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%%

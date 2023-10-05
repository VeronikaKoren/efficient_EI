clear all
close all

savefig=0;

figname='mse_ei_1pop';
savefile=[cd,'/figure/implementation/'];

addpath('/Users/vkoren/ei_net/result/connectivity/')

%% E-I net

loadname='Cnoise_factor_measures';
load(loadname)

mse_ei=sqrt(ms(1,:));

%% 1 population non-rectified

loadname='performance_1pop';
load(loadname,'ms')
mse_1pop=sqrt(ms);

%%
fs=13;
msize=6;
lw=1.2;
lwa=1;

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];

col={red,blue,'k'};
plt1=[0,0,8,8];

%xlb=Ct;
xvec=1:2;

xlimit=[0.5,2.5];
namep={'Exc','Inh','1 cell type'};

xlab={'E-I','1 cell type'};
yt=0:2:4;

%%

H=figure('name',figname);

hold on
b=bar(1,mse_ei,0.8,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = red;
b(2).FaceColor=blue;
bar(2,mse_1pop,0.3,'FaceColor','k','EdgeColor','k','Linewidth',lw);
hold off
box off

%op=get(gca,'OuterPosition');
%set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.08 op(3)-0.0 op(4)-0.08]);

for ii=1:3
    text(0.6,0.9-(ii-1)*0.12,namep{ii},'units','normalized','fontsize',fs,'color',col{ii})
end

xlim(xlimit)
ylim([0,4.5])

ylabel('Root MSE','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',1:4)
set(gca,'XTicklabel',xlab)
xtickangle(35)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end
%%

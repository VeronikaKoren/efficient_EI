clear all
close all

figname1='rmse_ei_1ct';
figname2='cost_ei_1ct';
figname3='sc_ei_1ct';
figname4='loss_ei_1ct';

savefig1=0;
savefig2=0;
savefig3=0;
savefig4=0;

savefile='/Users/vkoren/ei_net/figure/implementation/';
addpath('/Users/vkoren/ei_net/result/connectivity/')

%% E-I net

loadname='cost_sc_ei';
load(loadname)

rmse_ei=mean(Rmse,2);
mcost=mean(cost,2);
cost_ei=sum(mcost);
sc_ei=mean(sc,2);
loss_ei=mean(rmse_ei)+cost_ei;
%% 1 population non-rectified

loadname='cost_sc_1pop';
load(loadname)

rmse_1pop=mean(rmse1);
cost_1pop=mean(kappa1);
sc_1pop=mean(sc1);
loss_1pop=rmse_1pop+cost_1pop;
%%

fs=13;
msize=6;
lw=1.2;
lwa=1;
plt1=[0,0,7,6];

red=[0.85,0.32,0.1];
blue=[0,0.48,0.74];
purple=[0.7,0.1,0.7];
gray=[0.6,0.6,0.6];

coltxt={red,blue,[0.2,0.2,0.2]};
col2txt={purple,[0.2,0.2,0.2]};

xvec=1:2;
xlimit=[0.5,2.5];
namep={'Exc','Inh','1 cell type'};
namepp={'Exc+Inh','1 cell type'};
xlab={'E-I','1 CT'};

%% plot rmse

yt=0:2:4;
H=figure('name',figname1);

hold on
b=bar(1,rmse_ei,0.8,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = red;
b(2).FaceColor=blue;
bar(2,rmse_1pop,0.3,'FaceColor',gray,'EdgeColor','k','Linewidth',lw);
hold off
box off

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.08 op(3)-0.0 op(4)-0.08]);

for ii=1:3
    text(0.6,0.9-(ii-1)*0.12,namep{ii},'units','normalized','fontsize',fs,'color',coltxt{ii})
end

xlim(xlimit)
ylim([0,4.5])

ylabel('RMSE','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',1:4)
set(gca,'XTicklabel',xlab)
xtickangle(35)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig1==1
    print(H,[savefile,figname1],'-dpng','-r300');
end

%% plot cost

yt=4:4:12;

H=figure('name',figname2);

hold on
b=bar(1,cost_ei,0.3,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = purple;
bar(2,cost_1pop,0.3,'FaceColor',gray,'EdgeColor','k','Linewidth',lw);
hold off
box off

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.08 op(3)-0.0 op(4)-0.08]);

for ii=1:2
    text(0.1,0.9-(ii-1)*0.12,namepp{ii},'units','normalized','fontsize',fs,'color',col2txt{ii})
end

xlim(xlimit)
ylabel('metabolic cost','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',1:4)
set(gca,'XTicklabel',xlab)
xtickangle(35)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig2==1
    print(H,[savefile,figname2],'-dpng','-r300');
end

%% plot spike count

yt=10:10:30;

H=figure('name',figname3);

hold on
b=bar(1,sc_ei,0.8,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = red;
b(2).FaceColor=blue;
bar(2,sc_1pop,0.3,'FaceColor',gray,'EdgeColor','k','Linewidth',lw);
hold off
box off

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.08 op(3)-0.0 op(4)-0.08]);

for ii=1:3
    text(0.1,0.9-(ii-1)*0.12,namep{ii},'units','normalized','fontsize',fs,'color',coltxt{ii})
end

xlim(xlimit)
ylabel('firing rate','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',1:4)
set(gca,'XTicklabel',xlab)
xtickangle(35)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%%

yt=10:5:15;

H=figure('name',figname4);

hold on
b=bar(1,loss_ei,0.3,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = purple;
bar(2,loss_1pop,0.3,'FaceColor',gray,'EdgeColor','k','Linewidth',lw);
hold off
box off
op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.0 op(2)+0.08 op(3)-0.0 op(4)-0.08]);

for ii=1:2
    text(0.1,0.9-(ii-1)*0.12,namepp{ii},'units','normalized','fontsize',fs,'color',col2txt{ii})
end

xlim(xlimit)
ylim([0,20])
ylabel('average loss','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',1:4)
set(gca,'XTicklabel',xlab)
xtickangle(35)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')

set(H, 'Units','centimeters', 'Position', plt1)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt1(3), plt1(4)]) % for saving in the right size

if savefig3==1
    print(H,[savefile,figname3],'-dpng','-r300');
end

%% plot all 1 fig

%{
plt3=[0,0,18,6];
H=figure('name',figname);

yt=[10,40];
subplot(1,3,1)

hold on
b=bar(1,sc_ei,0.8,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = red;
b(2).FaceColor=blue;
bar(2,sc_1pop,0.3,'FaceColor',gray,'EdgeColor','k','Linewidth',lw);
hold off
box off

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.0 op(3)-0.02 op(4)-0.0]);

for ii=1:3
    text(0.1,0.9-(ii-1)*0.2,namep{ii},'units','normalized','fontsize',fs,'color',coltxt{ii})
end

xlim(xlimit)
ylim([0,50])
ylabel('firing rate [Hz]','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',1:4)
set(gca,'XTicklabel',[])


yt=[0,3];
subplot(1,3,2)
hold on
b=bar(1,rmse_ei,0.8,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = red;
b(2).FaceColor=blue;
bar(2,rmse_1pop,0.3,'FaceColor',gray,'EdgeColor','k','Linewidth',lw);
hold off
box off

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)+0.0 op(3)-0.02 op(4)-0.0]);

%{
for ii=1:3
    text(0.6,0.9-(ii-1)*0.12,namep{ii},'units','normalized','fontsize',fs,'color',coltxt{ii})
end
%}
xlim(xlimit)
ylim([0,4.5])

ylabel('RMSE','fontsize',fs)
set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',1:4)
set(gca,'XTicklabel',[])
%xtickangle(35)

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')


% plot cost
yt=[0,10];
subplot(1,3,3)
hold on
b=bar(1,cost_ei,0.3,'FaceColor','Flat','EdgeColor','k','Linewidth',lw);
b(1).FaceColor = purple;
bar(2,cost_1pop,0.3,'FaceColor',gray,'EdgeColor','k','Linewidth',lw);
hold off
box off

for ii=1:2
    text(0.1,0.9-(ii-1)*0.2,namepp{ii},'units','normalized','fontsize',fs,'color',col2txt{ii})
end

xlim(xlimit)
ylim([0,15])
ylabel('metabolic cost','fontsize',fs)

set(gca,'YTick',yt)
set(gca,'YTicklabel',yt,'fontsize',fs)
set(gca,'XTick',1:4)
set(gca,'XTicklabel',xlab)
xtickangle(35)

op=get(gca,'OuterPosition');
set(gca,'OuterPosition',[op(1)+0.02 op(2)-0.04 op(3)-0.02 op(4)+0.04]);

set(gca,'LineWidth',lwa,'TickLength',[0.015 0.015]);
set(gca,'TickDir','out')



set(H, 'Units','centimeters', 'Position', plt3)
set(H,'PaperPositionMode','Auto','PaperUnits', 'centimeters','PaperSize',[plt3(3), plt3(4)]) % for saving in the right size

if savefig==1
    print(H,[savefile,figname],'-dpng','-r300');
end

%}

